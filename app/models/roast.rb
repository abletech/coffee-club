class Roast < ApplicationRecord
  validates :company, :roastName, :description, presence: true
end