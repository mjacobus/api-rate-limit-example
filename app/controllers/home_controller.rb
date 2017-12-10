class HomeController < ApplicationController
  def index
    render plain: 'ok'
  end

  def show
    render json: { message: 'ok', time: Time.now.to_i, path: params[:path] }
  end
end
