class Location < ApplicationRecord
  belongs_to :person, inverse_of: :locations
end
