class Person < ApplicationRecord
  has_many :locations, inverse_of: :person
  has_many :affiliations, inverse_of: :person

  validates_associated :locations, :affiliations

  validates :first_name, :species, :gender, presence: true
end
