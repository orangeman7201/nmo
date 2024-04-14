require 'rails_helper'

RSpec.describe Condition, type: :model do
  describe 'validation' do
    subject { condition.valid? }

    context 'detail' do
      let(:condition) { build(:condition, detail: detail, user: user) }
      let(:user) { create(:user) }

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
      let!(:condition) { build(:condition, occurred_date: occurred_date, user: user) }
      let(:user) { create(:user) }

      context 'true' do
        let(:occurred_date) { '2024-01-01' }
        it { is_expected.to be_truthy }
      end

      context 'false' do
        let(:occurred_date) { nil }
        it { is_expected.to be_falsey }
      end
    end

    context 'strength' do
      let(:condition) { build(:condition, strength: strength, user: user) }
      let(:user) { create(:user) }

      context 'true' do
        let(:strength) { 1 }
        it { is_expected.to be_truthy }
      end

      context 'false' do
        let(:strength) { nil }
        it { is_expected.to be_falsey }
      end
    end
  end

  describe 'scope' do
    describe 'in_target_month' do
      subject { Condition.in_target_month(target_month) }

      before do
        create(:condition, occurred_date: '2024-01-01', user: create(:user))
        create(:condition, occurred_date: '2024-01-31', user: create(:user))
        create(:condition, occurred_date: '2024-02-01', user: create(:user))
      end

      context '2024-01' do
        let(:target_month) { '2024-01-01' }
        it { expect(subject.count).to eq 2 }
      end

      context '2024-02' do
        let(:target_month) { '2024-02-01' }
        it { expect(subject.count).to eq 1 }
      end
    end
  end
end
