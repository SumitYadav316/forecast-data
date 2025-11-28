require "rails_helper"

RSpec.describe ForecastsController, type: :controller do
  describe "POST #create" do
    it "redirects to forecast show page" do
      post :create, params: { address: "452001" }
      expect(response).to have_http_status(:redirect)
    end

    it "rejects blank input" do
      post :create, params: { address: "" }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Please provide an address or zipcode.")
    end
  end

  describe "GET #show" do
    let(:service_double) do
      double(
        success?: true,
        data: { current: { temp: 30 } },
        fetched_at: Time.now.utc,
        from_cache: false
      )
    end

    it "renders successful forecast" do
      allow(ForecastService).to receive(:new).and_return(double(call: service_double))

      get :show, params: { id: "indore" }

      expect(response).to have_http_status(:ok)
      expect(assigns(:forecast)).to eq(service_double.data)
    end

    it "renders error on failure" do
      allow(ForecastService).to receive(:new)
        .and_return(double(call: OpenStruct.new(success?: false, error: "Invalid")))

      get :show, params: { id: "xyz" }

      expect(response.status).to eq(400)
      expect(flash[:alert]).to eq("Invalid")
    end
  end
end
