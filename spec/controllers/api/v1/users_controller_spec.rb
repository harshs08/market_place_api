require 'spec_helper'

describe Api::V1::UsersController do

  before(:each) { request.headers['Accept'] = 'application/vnd.marketplace.v1' }

  describe "GET #show" do
    
    let(:user) { FactoryGirl.create :user }
    
    before (:each) do
      get :show, id: user.id, format: :json
    end

    it "returns the information about a user on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql user.email
    end

    it { is_expected.to respond_with 200 }
  end

end
