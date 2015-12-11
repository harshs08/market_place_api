require 'spec_helper'

describe Placement do
  let(:product) { FactoryGirl.build :product }
  let(:order)   { FactoryGirl.build :order }
  let(:placement) { FactoryGirl.build :placement, product_id: product.id, order_id: order.id }
  subject { placement }

  it { is_expected.to respond_to :order_id }
  it { is_expected.to respond_to :product_id }

  it { is_expected.to belong_to :order }
  it { is_expected.to belong_to :product }
end
