class CreateTournaments < ActiveRecord::Migration[5.2]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :organizer_id
      t.string :location
      t.string :state
      t.string :country
      t.date :date
      t.integer :format_id
      t.integer :version_id
      t.integer :tournament_type_id
      t.boolean :locked

      t.timestamps
    end
  end
end
