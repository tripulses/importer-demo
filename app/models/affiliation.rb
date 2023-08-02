class Affiliation < ApplicationRecord
  belongs_to :person, inverse_of: :affiliations
end
