require 'spec_helper'

describe Api::V1::OrdersController do
  describe "GET #index" do
    let(:current_user) { FactoryGirl.create :user }
    before(:each) do
      api_authorization_header current_user.auth_token
      4.times { FactoryGirl.create :order, user: current_user }
      get :index, user_id: current_user.id
    end

    it "returns 4 order records from the user" do
      order_response = json_response[:orders]
      expect(order_response.size).to eql(4)
    end

    it { is_expected.to respond_with 200 }
  end

  describe "GET #show" do
    let(:current_user) { FactoryGirl.create :user }
    let(:order) { FactoryGirl.create :order, user: current_user }
    before(:each) do
      api_authorization_header current_user.auth_token
      get :show, user_id: current_user.id, id: order.id
    end

    it "returns the order matching the id" do
      order_response = json_response[:order]
      expect(order_response[:id]).to eql order.id
    end

    it { is_expected.to respond_with 200 }
  end

end
