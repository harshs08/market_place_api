require 'spec_helper'

describe Product do
  let(:product) { FactoryGirl.build :product }
  subject { product }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:price) }
  it { is_expected.to respond_to(:published) }
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.not_to be_published }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_numericality_of(:price).
    is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of :user_id }

  it { is_expected.to belong_to :user }
end
