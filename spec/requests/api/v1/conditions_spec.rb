require 'rails_helper'

RSpec.describe "Api::V1::Conditions", type: :request do
  shared_examples 'response_200' do


    it 'レスポンスステータスが200であること' do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    subject { get "/api/v1/conditions" }

    it_behaves_like 'response_200'

    context 'データがあるとき' do
      before do
        create_list(:condition, 3)
      end

      it '全てのデータが取得できること' do
        subject
        json = JSON.parse(response.body)
        expect(json.length).to eq 3
      end
    end
  end

  describe "GET /show" do
    let(:condition) { create(:condition) }
    subject { get "/api/v1/conditions/#{condition.id}" }

    it_behaves_like 'response_200'

    it 'データが取得できること' do
      subject
      json = JSON.parse(response.body)
      expect(json['id']).to eq condition.id
    end
  end

  describe "POST /create" do
    let(:params) { { condition: attributes_for(:condition) } }
    subject { post "/api/v1/conditions", params: params }

    it 'データが作成できること' do
      expect { subject }.to change { Condition.count }.by(1)
    end
  end

  describe "PATCH /update" do
    let(:condition) { create(:condition) }
    let(:params) { { condition: { detail: 'new_detail' } } }
    subject { patch "/api/v1/conditions/#{condition.id}", params: params }

    it 'データが更新できること' do
      subject
      expect(condition.reload.detail).to eq 'new_detail'
    end
  end

  describe "DELETE /delete" do
    let!(:condition) { create(:condition) }
    subject { delete "/api/v1/conditions/#{condition.id}" }

    it 'データが削除できること' do
      expect { subject }.to change { Condition.count }.by(-1)
    end
  end
end
