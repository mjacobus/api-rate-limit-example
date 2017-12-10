class HomeController < ApplicationController
  def index
    render plain: 'ok'
  end

  def dump
    json = request.env.select do |_key, value|
      value.is_a?(String)
    end

    render json: json.to_json
  end
end
