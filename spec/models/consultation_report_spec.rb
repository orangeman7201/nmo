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

  describe 'instance method' do
    context '#set_date' do
      subject { consultation_report.set_date }
      let(:user) { create(:user) }
      let(:hospital_appointment) { create(:hospital_appointment, user: user, consultation_date: '2024-02-01') }
      let(:consultation_report) { build(:consultation_report, user: user, hospital_appointment: hospital_appointment, start_date: nil, end_date: nil) }

      it 'end_dateが設定される' do
        subject
        expect(consultation_report.end_date).to eq hospital_appointment.consultation_date
      end

      context '前のhospital_appointmentがない場合' do
        it 'start_dateが設定されない' do
          subject
          expect(consultation_report.start_date).to be_nil
        end
      end

      context '前のhospital_appointmentがある場合' do
        let!(:previous_hospital_appointment) { create(:hospital_appointment, user: user, consultation_date: '2024-01-01') }

        it 'start_dateが設定される' do
          subject
          expect(consultation_report.start_date).to eq previous_hospital_appointment.consultation_date
        end
      end
    end
  end
end
