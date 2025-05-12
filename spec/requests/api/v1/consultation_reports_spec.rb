require 'rails_helper'

RSpec.describe "Api::V1::ConsultationReports", type: :request do
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

  shared_examples 'response_422' do
    it '422が返却されること' do
      subject
      expect(response).to have_http_status(422)
    end
  end

  describe "GET /index" do
    subject { get "/api/v1/consultation_reports", headers: token }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:user) { create(:user) }
      let(:token) { sign_in user }

      context 'userに紐づくデータがあるとき' do
        before do
          create_list(:consultation_report, 3, user: user, hospital_appointment: create(:hospital_appointment, user: user))
        end

        it '全てのデータが取得できること' do
          subject
          json = JSON.parse(response.body)
          expect(json.length).to eq 3
        end
      end

      context 'userに紐づくデータがないとき' do
        let(:another_user) { create(:user) }

        before do
          create_list(:consultation_report, 3, user: another_user, hospital_appointment: create(:hospital_appointment, user: another_user))
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
    subject { get "/api/v1/consultation_reports/#{consultation_report.id}", headers: token }
    let(:user) { create(:user) }
    let(:consultation_report) { create(:consultation_report, user: user, hospital_appointment: create(:hospital_appointment, user: user)) }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:token) { sign_in user }

      it_behaves_like 'response_200'

      it 'データが取得できること' do
        subject
        json = JSON.parse(response.body)
        expect(json['id']).to eq consultation_report.id
      end

      context '他のユーザーのデータを取得しようとしたとき' do
        let(:another_user) { create(:user) }
        let(:consultation_report) { create(:consultation_report, user: another_user, hospital_appointment: create(:hospital_appointment, user: user)) }

        it 'データが取得できないこと' do
          subject
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe "POST /create" do
    let(:user) { create(:user) }
    let(:hospital_appointment) { create(:hospital_appointment, user: user) }
    let(:params) { { consultation_report: { hospital_appointment_id: hospital_appointment.id, consultation_memo: 'test' } } }
    subject { post "/api/v1/consultation_reports", params: params, headers: token }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:token) { sign_in user }

      it 'データが作成できること' do
        expect { subject }.to change { ConsultationReport.count }.by(1)
      end
    end
  end

  describe "PATCH /update" do
    let(:user) { create(:user) }
    let(:consultation_report) { create(:consultation_report, user: user, hospital_appointment: create(:hospital_appointment, user: user)) }
    let(:params) { { consultation_report: { consultation_memo: 'update' } } }
    subject { patch "/api/v1/consultation_reports/#{consultation_report.id}", params: params, headers: token }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:token) { sign_in user }

      it 'データが更新できること' do
        subject
        consultation_report.reload
        expect(consultation_report.consultation_memo).to eq 'update'
      end
    end
  end

  describe "DELETE /delete" do
    let(:user) { create(:user) }
    let!(:consultation_report) { create(:consultation_report, user: user, hospital_appointment: create(:hospital_appointment, user: user)) }
    subject { delete "/api/v1/consultation_reports/#{consultation_report.id}", headers: token }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:token) { sign_in user }

      it 'データが削除できること' do
        expect { subject }.to change { ConsultationReport.count }.by(-1)
      end
    end
  end

  describe "POST /generate_ai_summary" do
    let(:user) { create(:user) }
    let(:hospital_appointment) { create(:hospital_appointment, user: user) }
    let(:consultation_report) { create(:consultation_report, user: user, hospital_appointment: hospital_appointment) }
    subject { post "/api/v1/consultation_reports/#{consultation_report.id}/generate_ai_summary", headers: token }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:token) { sign_in user }

      context '体調情報が存在しないとき' do
        it_behaves_like 'response_422'

        it 'エラーメッセージが返却されること' do
          subject
          json = JSON.parse(response.body)
          expect(json['success']).to eq false
          expect(json['message']).to eq '要約するための体調情報がありません。'
        end
      end

      context '体調情報が存在するとき' do
        before do
          # 日付範囲内の体調情報を作成
          create_list(:condition, 3, user: user, occurred_date: consultation_report.start_date + 1.day)
          
          # ChatGptのモック
          allow_any_instance_of(ChatGpt).to receive(:chat).and_return('{"summary": "テスト要約", "details": "詳細情報"}')
        end

        it_behaves_like 'response_200'

        it 'AI要約が生成されること' do
          subject
          json = JSON.parse(response.body)
          expect(json['success']).to eq true
          expect(json['message']).to eq 'AI要約が生成されました。'
          expect(json['condition_summary']).to be_present
        end

        it 'consultation_reportのcondition_summaryが更新されること' do
          subject
          consultation_report.reload
          expect(consultation_report.condition_summary).to be_present
        end
      end

      context 'ChatGptでエラーが発生したとき' do
        before do
          create_list(:condition, 3, user: user, occurred_date: consultation_report.start_date + 1.day)
          allow_any_instance_of(ChatGpt).to receive(:chat).and_raise(StandardError.new('API error'))
        end

        it_behaves_like 'response_422'

        it 'エラーメッセージが返却されること' do
          subject
          json = JSON.parse(response.body)
          expect(json['success']).to eq false
          expect(json['message']).to eq 'AI要約の生成に失敗しました。'
        end
      end
    end
  end
end
