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
    let(:product_1) { FactoryGirl.create :product, price: 100 }
    let(:product_2) { FactoryGirl.create :product, price: 85 }
    let(:placement_1) { FactoryGirl.build :placement, product: product_1, quantity: 3 }
    let(:placement_2) { FactoryGirl.build :placement, product: product_2, quantity: 15 }
    let(:order) { FactoryGirl.build :order }

    before(:each) do
      order.placements << placement_1
      order.placements << placement_2
    end

    it "returns the total amount to pay for the products" do
      expect{order.set_total!}.to change{order.total.to_f}.from(0).to(1575)
    end
  end

  describe "#build_placements_with_product_ids_and_quantities" do
    let(:product_1) { FactoryGirl.create :product, price: 100, quantity: 5 }
    let(:product_2) { FactoryGirl.create :product, price: 85, quantity: 10 }

    before(:each) do
      @product_ids_and_quantities = [[product_1.id, 2], [product_2.id, 3]]
    end

    it "builds 2 placements for the order" do
      expect{order.build_placements_with_product_ids_and_quantities(@product_ids_and_quantities)
        }.to change{order.placements.size}.from(0).to(2)
    end
  end

  describe "#valid?" do
    let(:product_1) { FactoryGirl.create :product, price: 100, quantity: 5 }
    let(:product_2) { FactoryGirl.create :product, price: 85, quantity: 10 }
    let(:placement_1) { FactoryGirl.build :placement, product: product_1, quantity: 3 }
    let(:placement_2) { FactoryGirl.build :placement, product: product_2, quantity: 15 }
    let(:order) { FactoryGirl.build :order }

    before do
      order.placements << placement_1
      order.placements << placement_2
    end

    it "becomes invalid due to insufficient products" do
      expect(order).to_not be_valid
    end
  end
end
