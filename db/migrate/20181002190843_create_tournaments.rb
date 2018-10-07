class CreateTournaments < ActiveRecord::Migration[5.2]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :organizer_id
      t.string :location
      t.integer :format_id
      t.date :date
      t.integer :version_id
      t.integer :tournamenttype_id
      t.string :country

      t.timestamps
    end
  end
end
