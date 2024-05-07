require 'rails_helper'

RSpec.describe HospitalAppointment, type: :model do
  describe 'validation' do
    subject { hospital_appointment.valid? }

    context 'consultation_date' do
      let(:hospital_appointment) { build(:hospital_appointment, consultation_date: consultation_date, user: user) }
      let(:user) { create(:user) }

      context 'true' do
        let(:consultation_date) { '2024-04-16' }
        it { is_expected.to be_truthy }
      end

      context 'false' do
        let(:consultation_date) { nil }
        it { is_expected.to be_falsey }
      end
    end
  end

  describe 'instance method' do
    context '#previous_hospital_appointment' do
      subject { hospital_appointment.previous_hospital_appointment }
      let(:user) { create(:user) }
      let(:hospital_appointment) { create(:hospital_appointment, consultation_date: '2024-04-16', user: user) }

      context '前のhospital_appointmentがある場合' do
        let!(:previous_hospital_appointment) { create(:hospital_appointment, consultation_date: '2024-04-15', user: user) }

        it '前のhospital_appointmentが取得できる' do
          expect(subject).to eq previous_hospital_appointment
        end
      end

      context '前のhospital_appointmentがない場合' do
        it 'nilが返る' do
          expect(subject).to be_nil
        end
      end
    end
  end
end
