require 'spec_helper'

require 'waiting'

describe Waiting do
  let(:default_exp_base) { 1 }
  let(:default_interval) { 2 }
  let(:default_max_attempts) { 3 }
  let(:default_max_interval) { 4 }

  before do
    described_class.default_exp_base = default_exp_base
    described_class.default_interval = default_interval
    described_class.default_max_attempts = default_max_attempts
    described_class.default_max_interval = default_max_interval
  end

  describe '.wait' do
    it 'uses the defaults' do
      described_class.wait do |w|
        expect(w.exp_base).to eq(default_exp_base)
        expect(w.interval).to eq(default_interval)
        expect(w.max_attempts).to eq(default_max_attempts)
        expect(w.max_attempts).to eq(default_max_attempts)
        w.done
      end
    end
  end

  describe '#wait' do
    it 'uses the defaults' do
      subject.wait do |w|
        expect(w.exp_base).to eq(default_exp_base)
        expect(w.interval).to eq(default_interval)
        expect(w.max_attempts).to eq(default_max_attempts)
        expect(w.max_attempts).to eq(default_max_attempts)
        w.done
      end
    end

    context 'when passing instance parameters' do
      let(:instance_exp_base) { 5 }
      let(:instance_interval) { 6 }
      let(:instance_max_attempts) { 7 }
      let(:instance_max_interval) { 8 }

      subject do
        described_class.new(exp_base: instance_exp_base,
                            interval: instance_interval,
                            max_attempts: instance_max_attempts,
                            max_interval: instance_max_interval) do |w|
          expect(w.exp_base).to eq(instance_exp_base)
          expect(w.interval).to eq(instance_interval)
          expect(w.max_attempts).to eq(instance_max_attempts)
          expect(w.max_attempts).to eq(instance_max_attempts)
          w.done
        end
      end

      it 'uses the instance parameters' do
        subject.wait
      end

      context 'when passing in method parameters' do
        let(:exp_base) { 9 }
        let(:interval) { 10 }
        let(:max_attempts) { 11 }
        let(:max_interval) { 12 }

        it 'uses the method parameters' do
          subject.wait(exp_base: exp_base,
                       interval: interval,
                       max_attempts: max_attempts,
                       max_interval: max_interval) do |w|
            expect(w.exp_base).to eq(exp_base)
            expect(w.interval).to eq(interval)
            expect(w.max_attempts).to eq(max_attempts)
            expect(w.max_attempts).to eq(max_attempts)
            w.done
          end
        end
      end
    end
  end
end
