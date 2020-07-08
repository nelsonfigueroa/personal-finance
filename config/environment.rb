# frozen_string_literal: true

# configure logging
Rails.logger = Logger.new(STDOUT)
Rails.logger.level = Logger::DEBUG

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
