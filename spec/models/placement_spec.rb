require 'spec_helper'

describe Placement do
  let(:product) { FactoryGirl.build :product }
  let(:order)   { FactoryGirl.build :order }
  let(:placement) { FactoryGirl.build :placement, product: product, order_id: order }
  subject { placement }

  it { is_expected.to respond_to :order_id }
  it { is_expected.to respond_to :product_id }
  it { is_expected.to respond_to :quantity }

  describe "#decrement_product_quantity!" do
    it "decreases the product quantity by the placement quantity" do
      product = placement.product
      expect{placement.decrement_product_quantity!}.to change{product.quantity}.by(-placement.quantity)
    end
  end

  it { is_expected.to belong_to :order }
  it { is_expected.to belong_to :product }
end
