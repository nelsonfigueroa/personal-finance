# frozen_string_literal: true

class Api::V1::SystemController < ApplicationController
  def health
    render json: 'Healthy'
  end
end
