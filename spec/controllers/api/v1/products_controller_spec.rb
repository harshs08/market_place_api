require 'spec_helper'

describe Api::V1::ProductsController do

  describe "GET #show" do
    let(:product) { FactoryGirl.create :product }
    before(:each) do
      get :show, id: product.id
    end 

    it "returns the information a product in hash" do
      product_reponse = json_response[:product]
      expect(product_reponse[:title]).to eq product.title
    end

    it { is_expected.to respond_with 200 }
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :product }
      get :index
    end

    it "returns 4 records from the database" do
      product_reponse = json_response
      expect(product_reponse[:products].count).to eq(4)
    end

    it { is_expected.to respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      let(:user) { FactoryGirl.create :user }
      let(:product_attributes) { FactoryGirl.attributes_for :product }
      before(:each) do
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: product_attributes }
      end

      it "renders the json representation for the product record just created" do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql product_attributes[:title]
      end

      it { is_expected.to respond_with 201 }
    end

    context "when is not created" do
      let(:user) { FactoryGirl.create :user }

      before(:each) do
        @invalid_product_attributes = { title: "Smart TV", price: "Twelve dollars" }
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @invalid_product_attributes }
      end

      it "renders an errors json" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    let(:user) { FactoryGirl.create :user }
    let(:product) { FactoryGirl.create :product, user: user }
    before(:each) do
      api_authorization_header user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: user.id, id: product.id,
              product: { title: "An expensive TV" } }
      end

      it "renders the json representation for the updated user" do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql "An expensive TV"
      end

      it { is_expected.to respond_with 200 }
    end

    context "is not updated" do
      before(:each) do
        patch :update, {user_id: user.id, id: product.id,
          product: { price: "two hundred" }}
      end

      it "renders an errors json" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    let(:user) { FactoryGirl.create :user }
    let(:product) { FactoryGirl.create :product, user: user }
    before(:each) do
      api_authorization_header user.auth_token
      delete :destroy, { user_id: user.id, id: product.id }
    end

    it { is_expected.to respond_with 204 }
  end

end
