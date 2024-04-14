require 'rails_helper'

RSpec.describe "Api::V1::Conditions", type: :request do
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
    subject { get "/api/v1/conditions", headers: token }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:user) { create(:user) }
      let(:token) { sign_in user }

      context 'userに紐づくデータがあるとき' do
        before do
          create_list(:condition, 3, user: user, occurred_date: '2024-01-01')
        end

        context 'target_monthで指定されているとき' do
          subject { get "/api/v1/conditions", params: { target_month: '2024-01-01' }, headers: token }

          it '全てのデータが取得できること'  do
            subject
            json = JSON.parse(response.body)
            expect(json.length).to eq 3
          end
        end

        context 'target_monthで指定されていないとき' do
          subject { get "/api/v1/conditions", params: { target_month: '2024-02-01' }, headers: token }

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
          create_list(:condition, 3, user: another_user)
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
    subject { get "/api/v1/conditions/#{condition.id}", headers: token }
    let(:user) { create(:user) }
    let(:condition) { create(:condition, user: user) }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:token) { sign_in user }

      context 'userに紐づくデータのとき' do
        it 'データが取得できること' do
          subject
          json = JSON.parse(response.body)
          expect(json['id']).to eq condition.id
        end
      end

      context 'userに紐づかないデータのとき' do
        let(:condition) { create(:condition, user: create(:user)) }

        it 'データが取得できないこと' do
          subject
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe "POST /create" do
    let(:params) { { condition: attributes_for(:condition) } }
    subject { post "/api/v1/conditions", params: params, headers: token }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:user) { create(:user) }
      let(:token) { sign_in user }

      it 'データが作成できること' do
        expect { subject }.to change { Condition.count }.by(1)
      end
    end
  end

  describe "PATCH /update" do
    let(:condition) { create(:condition, user: user) }
    let(:params) { { condition: { detail: 'new_detail' } } }
    subject { patch "/api/v1/conditions/#{condition.id}", params: params, headers: token }
    let(:user) { create(:user) }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログイしているとき' do
      let(:token) { sign_in user }

      it 'データが更新できること' do
        subject
        expect(condition.reload.detail).to eq 'new_detail'
      end
    end
  end

  describe "DELETE /delete" do
    let!(:condition) { create(:condition, user: user) }
    let(:user) { create(:user) }
    let(:token) { nil }
    subject { delete "/api/v1/conditions/#{condition.id}", headers: token }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:token) { sign_in user }

      it 'データが削除できること' do
        expect { subject }.to change { Condition.count }.by(-1)
      end
    end
  end
end
