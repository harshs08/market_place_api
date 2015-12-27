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

    it "return the user object into each product" do
      product_response = json_response[:product]
      expect(product_response[:user][:email]).to eq product.user.email
    end
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :product }
      get :index
    end

    it "returns 4 records from the database" do
      products_response = json_response[:products]
      expect(products_response.count).to eq(4)
    end

    it "returns the user object into each product" do
      products_response = json_response[:products]
      products_response.each do |product_response|
        expect(product_response[:user]).to be_present
      end
    end

    it { expect(json_response).to have_key(:meta) }
    it { expect(json_response[:meta]).to have_key(:pagination) }
    it { expect(json_response[:meta][:pagination]).to have_key(:per_page) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_pages) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_objects) }

    it { is_expected.to respond_with 200 }

    context "when product_ids parameter is sent" do
      let(:user) { FactoryGirl.create :user}
      before(:each) do
        3.times { FactoryGirl.create :product, user: user }
        get :index, product_ids: user.product_ids
      end

      it "returns just the products that belong to the user" do
        products_response = json_response[:products]

        products_response.each do |product_response|
          expect(product_response[:user][:email]).to eql user.email
        end
      end
    end
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
