class CreateAffiliations < ActiveRecord::Migration[5.2]
  def change
    create_table :affiliations do |t|
      t.string :affiliation_name

      t.integer :person_id

      t.timestamps
    end
  end
end
