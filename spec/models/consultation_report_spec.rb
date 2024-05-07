require 'rails_helper'

RSpec.describe ConsultationReport, type: :model do
  describe 'validation' do
    subject { consultation_report.valid? }
    let(:user) { create(:user) }
    let(:hospital_appointment) { create(:hospital_appointment, user: user) }
    let(:consultation_report) { build(:consultation_report, end_date: end_date, user: user, hospital_appointment: hospital_appointment) }
    let(:end_date) { '2024-02-01' }

    context 'end_date' do
      context 'true' do
        it { is_expected.to be_truthy }
      end

      context 'false' do
        let(:end_date) { nil }
        it { is_expected.to be_falsey }
      end
    end
  end
end
