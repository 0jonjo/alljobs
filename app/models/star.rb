# frozen_string_literal: true

class Star < ApplicationRecord
  belongs_to :headhunter
  belongs_to :apply
end
