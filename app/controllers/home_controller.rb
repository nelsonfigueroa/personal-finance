# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def faq; end

  def dashboard
    @user = current_user
  end
end
