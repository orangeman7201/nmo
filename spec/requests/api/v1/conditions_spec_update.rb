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

  describe "GET /up_to_date" do
    subject { get "/api/v1/conditions/up_to_date", params: { end_date: end_date }, headers: token }
    let(:user) { create(:user) }
    let(:end_date) { Time.current.to_date.to_s }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:token) { sign_in user }

      it_behaves_like 'response_200'

      context 'userに紐づくデータがあるとき' do
        before do
          create_list(:condition, 3, user: user, occurred_date: Time.current.to_date - 1.day)
          create_list(:condition, 2, user: user, occurred_date: Time.current.to_date + 1.day)
        end

        it '指定日付以前のデータのみが取得できること' do
          subject
          json = JSON.parse(response.body)
          expect(json.length).to eq 3
        end
      end

      context 'userに紐づくデータがないとき' do
        let(:another_user) { create(:user) }

        before do
          create_list(:condition, 3, user: another_user, occurred_date: Time.current.to_date - 1.day)
        end

        it '空の配列が返却されること' do
          subject
          json = JSON.parse(response.body)
          expect(json.length).to eq 0
        end
      end
    end
  end

  describe "GET /between_dates" do
    subject { get "/api/v1/conditions/between_dates", params: { start_date: start_date, end_date: end_date }, headers: token }
    let(:user) { create(:user) }
    let(:start_date) { (Time.current.to_date - 5.days).to_s }
    let(:end_date) { Time.current.to_date.to_s }
    let(:token) { nil }

    it_behaves_like 'response_401'

    context 'ログインしているとき' do
      let(:token) { sign_in user }

      it_behaves_like 'response_200'

      context 'userに紐づくデータがあるとき' do
        before do
          # 範囲内のデータ
          create_list(:condition, 2, user: user, occurred_date: Time.current.to_date - 3.days)
          # 範囲外のデータ
          create_list(:condition, 1, user: user, occurred_date: Time.current.to_date - 6.days)
          create_list(:condition, 1, user: user, occurred_date: Time.current.to_date + 1.day)
        end

        it '指定日付範囲内のデータのみが取得できること' do
          subject
          json = JSON.parse(response.body)
          expect(json.length).to eq 2
        end
      end

      context 'userに紐づくデータがないとき' do
        let(:another_user) { create(:user) }

        before do
          create_list(:condition, 3, user: another_user, occurred_date: Time.current.to_date - 3.days)
        end

        it '空の配列が返却されること' do
          subject
          json = JSON.parse(response.body)
          expect(json.length).to eq 0
        end
      end
    end
  end
end
