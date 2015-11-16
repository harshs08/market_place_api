require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }

  subject { user }

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:email) }
  # it { is_expected.to validate_uniqueness_of(:email) } # commented out because of a bug in shoulda matcher with devise
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('example@domain.com').for(:email) }
end
