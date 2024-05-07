require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'instance method' do
    context '#have_hospital_appointments?' do
      subject { user.have_hospital_appointments? }
      let(:user) { create(:user) }

      context 'hospital_appointmentが2つ以上ある場合' do
        let!(:hospital_appointment1) { create(:hospital_appointment, user: user) }
        let!(:hospital_appointment2) { create(:hospital_appointment, user: user) }

        it 'trueを返す' do
          expect(subject).to be_truthy
        end
      end

      context 'hospital_appointmentが1つ以下の場合' do
        let!(:hospital_appointment) { create(:hospital_appointment, user: user) }

        it 'falseを返す' do
          expect(subject).to be_falsey
        end
      end
    end
  end
end