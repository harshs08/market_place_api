require 'spec_helper'

describe Api::V1::ProductsController do

  describe "GET #show" do
    let(:product) { FactoryGirl.create :product }
    before(:each) do
      get :show, id: product.id
    end 

    it "returns the information a product in hash" do
      product_reponse = json_response
      expect(product_reponse[:title]).to eq product.title
    end

    it { is_expected.to respond_with 200 }
  end

  describe "GET #index" do
    # let(:products) do
    #   4.times { FactoryGirl.create :product }
    # end
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

end
