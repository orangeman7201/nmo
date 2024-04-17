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
end
