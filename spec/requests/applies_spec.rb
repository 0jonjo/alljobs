require 'rails_helper'

RSpec.describe "Applies", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/applies/index"
      expect(response).to have_http_status(:success)
    end
  end

end
