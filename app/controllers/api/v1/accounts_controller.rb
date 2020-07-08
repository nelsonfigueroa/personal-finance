class Api::V1::AccountsController < ApplicationController

  def index
    # no need to specify json, this is configured in routes under :api namespace
    # render json: User.all

    User.all
  end
end