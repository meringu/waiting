require 'spec_helper'

require 'waiting/waiter'

describe Waiting::Waiter do
  describe '#wait' do
    let(:exp_base) { 1 }
    let(:interval) { 1 }
    let(:max_attempts) { 5 }
    let(:max_interval) { nil }
    let(:attempts) { 5 }

    let(:wait) do
      proc do
        subject.wait do |w|
          @attempt += 1
          w.done if @attempt >= attempts
        end
      end.call
    end

    subject do
      @attempt = 0
      described_class.new(exp_base: exp_base,
                          interval: interval,
                          max_attempts: max_attempts,
                          max_interval: max_interval)
    end

    shared_examples_for 'an in time waiter' do
      before do
        expect(subject)
          .to receive(:sleep)
          .with(interval)
          .exactly(attempts - 1).times
      end

      it 'waits' do
        wait
      end
    end

    shared_examples_for 'a timed out waiter' do
      before do
        expect(subject)
          .to receive(:sleep)
          .with(interval)
          .exactly(max_attempts).times
      end

      it 'throws' do
        expect { wait }.to raise_error(Waiting::TimedOutError)
      end
    end

    context 'attempts < max_attempts' do
      let(:attempts) { 4 }

      it_behaves_like 'an in time waiter'
    end

    context 'attempts == max_attempts' do
      let(:attempts) { 5 }

      it_behaves_like 'an in time waiter'
    end

    context 'attempts > max_attempts' do
      let(:attempts) { 6 }

      it_behaves_like 'a timed out waiter'
    end

    context 'exponential backoff' do
      context 'attempts == max_attempts' do
        let(:exp_base) { 2 }

        before do
          expect(subject).to receive(:sleep).with(1)
          expect(subject).to receive(:sleep).with(2)
          expect(subject).to receive(:sleep).with(4)
        end

        context 'when setting a max_interval' do
          let(:max_interval) { 5 }

          before do
            expect(subject).to receive(:sleep).with(5)
          end

          it 'waits' do
            wait
          end
        end

        context 'with no max interval' do
          before do
            expect(subject).to receive(:sleep).with(8)
          end

          it 'waits' do
            wait
          end
        end
      end
    end
  end
end
