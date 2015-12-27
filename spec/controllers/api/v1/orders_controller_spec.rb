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

    it { expect(json_response).to have_key(:meta) }
    it { expect(json_response[:meta]).to have_key(:pagination) }
    it { expect(json_response[:meta][:pagination]).to have_key(:per_page)}
    it { expect(json_response[:meta][:pagination]).to have_key(:total_pages) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_objects) }

    it { is_expected.to respond_with 200 }
  end

  describe "GET #show" do
    let(:current_user) { FactoryGirl.create :user }
    let(:product) { FactoryGirl.create :product }
    let(:order) { FactoryGirl.create :order, user: current_user,
     product_ids: [product.id] }
    before(:each) do
      api_authorization_header current_user.auth_token
      get :show, user_id: current_user.id, id: order.id
    end

    it "returns the order matching the id" do
      order_response = json_response[:order]
      expect(order_response[:id]).to eql order.id
    end

    it "includes the total for the order" do
      order_response = json_response[:order]
      expect(order_response[:total]).to eql order.total.to_s
    end

    it "includes the products on the order" do
      order_response = json_response[:order]
      expect(order_response[:products].size).to eq(1)
    end

    it { is_expected.to respond_with 200 }
  end

  describe "POST #create" do
    let(:current_user) { FactoryGirl.create :user }
    let(:product_1) { FactoryGirl.create :product }
    let(:product_2) { FactoryGirl.create :product }
    before(:each) do
      api_authorization_header current_user.auth_token
      order_params = { product_ids_and_quantities: [[product_1.id, 2],[ product_2.id, 3]] }
      post :create, user_id: current_user.id, order: order_params
    end

    it "returns just user order record" do
      order_response = json_response[:order]
      expect(order_response[:id]).to be_present
    end

    it "embeds the two product objects related to the order" do
      order_response = json_response[:order]
      expect(order_response[:products].size).to eql 2
    end

    it { is_expected.to respond_with 201 }
  end

end
