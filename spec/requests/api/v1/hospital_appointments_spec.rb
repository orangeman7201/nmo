require 'rails_helper'

RSpec.describe "Api::V1::HospitalAppointments", type: :request do
  shared_examples 'response_200' do
    it 'レスポンスステータスが200であること' do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  shared_examples 'response_401' do
    it '401が返却されること' do
      subject
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /index" do
    subject { get "/api/v1/hospital_appointments", headers: token }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:user) { create(:user) }
      let(:token) { sign_in user }

      context 'userに紐づくデータがあるとき' do
        before do
          create_list(:hospital_appointment, 3, user: user, consultation_date: '2024-01-01')
        end

        context 'target_monthで指定されているとき' do
          subject { get "/api/v1/hospital_appointments", params: { target_month: '2024-01-01' }, headers: token }

          it '全てのデータが取得できること'  do
            subject
            json = JSON.parse(response.body)
            expect(json.length).to eq 3
          end
        end

        context 'target_monthで指定されていないとき' do
          subject { get "/api/v1/hospital_appointments", params: { target_month: '2024-02-01' }, headers: token }

          it '空の配列が返却されること' do
            subject
            json = JSON.parse(response.body)
            expect(json.length).to eq 0
          end
        end
      end

      context 'userに紐づくデータがないとき' do
        let(:another_user) { create(:user) }

        before do
          create_list(:hospital_appointment, 3, user: another_user)
        end

        it '空の配列が返却されること' do
          subject
          json = JSON.parse(response.body)
          expect(json.length).to eq 0
        end
      end
    end
  end

  describe "GET /show" do
    subject { get "/api/v1/hospital_appointments/#{hospital_appointment.id}", headers: token }
    let(:user) { create(:user) }
    let(:hospital_appointment) { create(:hospital_appointment, user: user) }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:token) { sign_in user }

      context 'userに紐づくデータのとき' do
        it 'データが取得できること' do
          subject
          json = JSON.parse(response.body)
          expect(json['id']).to eq hospital_appointment.id
        end
      end

      context 'userに紐づかないデータのとき' do
        let(:hospital_appointment) { create(:hospital_appointment, user: create(:user)) }

        it 'データが取得できないこと' do
          subject
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe "POST /create" do
    let(:params) { { hospital_appointment: attributes_for(:hospital_appointment) } }
    subject { post "/api/v1/hospital_appointments", params: params, headers: token }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:user) { create(:user) }
      let(:token) { sign_in user }

      it 'データが作成できること' do
        expect { subject }.to change { HospitalAppointment.count }.by(1)
      end
    end
  end

  describe "PATCH /update" do
    let(:hospital_appointment) { create(:hospital_appointment, user: user) }
    let(:params) { { hospital_appointment: { memo: 'new_memo' } } }
    subject { patch "/api/v1/hospital_appointments/#{hospital_appointment.id}", params: params, headers: token }
    let(:user) { create(:user) }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログイしているとき' do
      let(:token) { sign_in user }

      it 'データが更新できること' do
        subject
        expect(hospital_appointment.reload.memo).to eq 'new_memo'
      end
    end
  end

  describe "DELETE /delete" do
    let!(:hospital_appointment) { create(:hospital_appointment, user: user) }
    let(:user) { create(:user) }
    let(:token) { nil }
    subject { delete "/api/v1/hospital_appointments/#{hospital_appointment.id}", headers: token }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:token) { sign_in user }

      it 'データが削除できること' do
        expect { subject }.to change { HospitalAppointment.count }.by(-1)
      end
    end
  end
end
