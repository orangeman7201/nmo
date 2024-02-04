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
end
