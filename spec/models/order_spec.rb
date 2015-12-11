require 'spec_helper'

describe Order do
  let(:order) { FactoryGirl.build :order }
  subject { order }

  it { is_expected.to respond_to(:total) }
  it { is_expected.to respond_to(:user_id) }

  it { is_expected.to validate_presence_of :user_id }

  it { is_expected.to belong_to :user }

  it { is_expected.to have_many(:placements) }
  it { is_expected.to have_many(:products).through(:placements) }

  describe "#set_total!" do
    let(:current_user) { FactoryGirl.create :user }
    let!(:product_1) { FactoryGirl.create :product, price: 100 }
    let!(:product_2) { FactoryGirl.create :product, price: 85 }
    let!(:order) { FactoryGirl.build :order, product_ids: [product_1.id, product_2.id] }

    it "returns the total amount to pay for the products" do
      expect{order.set_total!}.to change{order.total}.from(0).to(185)
    end
  end
end
