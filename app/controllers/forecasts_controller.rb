class ForecastsController < ApplicationController
  def new
  end

  def create
    address = params[:address].to_s.strip
    if address.blank?
      redirect_to root_path, alert: "Please provide an address or zipcode."
      return
    end

    zip = extract_zip(address)
    redirect_to forecast_path(id: zip || address, q: address)
  end

  def show
    @query = params[:q] || params[:id]

    service = ForecastService.new(@query).call

    if service.success?
      @forecast   = service.data
      @fetched_at = service.fetched_at
      @from_cache = service.from_cache
    else
      flash.now[:alert] = service.error
      render :new, status: :bad_request
    end
  end

  private

  def extract_zip(text)
    m = text.to_s.match(/\b\d{5,6}\b/)
    m && m[0]
  end
end
