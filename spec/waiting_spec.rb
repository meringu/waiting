require 'spec_helper'

describe Waiting do
  describe '#wait' do
    let(:max_attempts) { 5 }
    let(:interval) { 1 }

    subject { described_class }

    before do
      Waiting.default_max_attempts = max_attempts
      Waiting.default_interval = interval
    end

    shared_examples_for 'an in time waiter' do
      before do
        expect(subject).to receive(:sleep).with(interval).exactly(attempts - 1).times
      end

      it 'waits' do
        attempt = 0
        subject.wait do |w|
          attempt += 1
          w.done if attempt >= attempts
        end
      end
    end

    shared_examples_for 'a timed out waiter' do
      before do
        expect(subject).to receive(:sleep).with(interval).exactly(max_attempts).times
      end

      it 'throws' do
        attempt = 0
        expect do
          subject.wait do |w|
            attempt += 1
            w.done if attempt >= attempts
          end
        end.to raise_error(Waiting::TimedOutError, "Timed out after #{max_attempts * interval}s")
      end
    end

    context 'overriden defaults' do
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
    end

    context 'exponential backoff' do
      context 'attempts == max_attempts' do
        let(:attempts) { 5 }

        before do
          expect(subject).to receive(:sleep).with(1)
          expect(subject).to receive(:sleep).with(2)
          expect(subject).to receive(:sleep).with(4)
        end

        context 'when setting a max_interval' do
          before do
            expect(subject).to receive(:sleep).with(5)
          end

          it 'waits' do
            attempt = 0
            subject.wait(max_interval: 5, exp_base: 2, max_attempts: attempts) do |w|
              attempt += 1
              w.done if attempt >= attempts
            end
          end
        end

        context 'with no max interval' do
          before do
            expect(subject).to receive(:sleep).with(8)
          end

          it 'waits' do
            attempt = 0
            subject.wait(exp_base: 2, max_attempts: attempts) do |w|
              attempt += 1
              w.done if attempt >= attempts
            end
          end
        end
      end
    end
  end
end
