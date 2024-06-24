# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # current year to be used throughout app models
  CURRENT_YEAR = Time.zone.now.year
end
