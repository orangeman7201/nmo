require 'rails_helper'

RSpec.describe Condition, type: :model do
  describe 'validation' do
    subject { condition.valid? }

    context 'detail' do
      let!(:condition) { build(:condition, detail: detail) }

      context 'true' do
        let(:detail) { '症状の詳細' }
        it { is_expected.to be_truthy }
      end

      context 'false' do
        let(:detail) { nil }
        it { is_expected.to be_falsey }
      end
    end

    context 'occurred_date' do
      let!(:condition) { build(:condition, occurred_date: occurred_date) }

      context 'true' do
        let(:occurred_date) { '2024-01-01' }
        it { is_expected.to be_truthy }
      end

      context 'false' do
        let(:occurred_date) { nil }
        it { is_expected.to be_falsey }
      end
    end
  end
end
