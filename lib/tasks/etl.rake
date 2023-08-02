require 'csv'
Bundler.require

$: << File.join(File.dirname(__FILE__), '..')

namespace :etl do
  desc "Import Sentia coding test data"
  task :import_sample_data, [:path] => :environment do |t, args|
    data = args[:path] || File.expand_path('lib/tasks/Data.txt')

    CSV.read(data, headers: true, col_sep: ',').each do |row|
      next if row['Affiliations'].blank?

      firstname = row['Name'].split(' ').first
      lastname = row['Name'].split(' ').first != row['Name'].split(' ').last ? row['Name'].split(' ').last : nil
      
      person = Person.create!(
                first_name:   firstname&.titleize,
                last_name:    lastname&.titleize,
                species:      row['Species'],
                gender:       sanitize_gender(row['Gender']),
                weapon:       row['Weapon'],
                vehicle:      row['Vehicle']
      )

      person.locations = get_location_or_affiliation('location', row['Location'], person.id)
      person.affiliations = get_location_or_affiliation('affiliation', row['Affiliations'], person.id)
      person.save!
    end
  end

  private

  def get_location_or_affiliation(field, params, person_id)
    values = []

    if field == 'location'
      params.split(', ').each do |val|
        values << Location.where(location_name: val&.titleize, person_id: person_id).first_or_create!
      end
    elsif field == 'affiliation'
      params.split(', ').each do |val|
        values << Affiliation.where(affiliation_name: val&.titleize, person_id: person_id).first_or_create!
      end
    end

    return values
  end

  def sanitize_gender(gender)
    return 'Male' if gender.downcase == 'm'
    return 'Female' if gender.downcase == 'f'

    return gender
  end
end