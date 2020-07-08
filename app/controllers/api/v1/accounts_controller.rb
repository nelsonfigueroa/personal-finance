# frozen_string_literal: true

class Api::V1::AccountsController < ApplicationController
  def index
    render json: User.all
  end
end
