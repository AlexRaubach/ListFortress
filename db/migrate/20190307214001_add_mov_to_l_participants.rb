class AddMovToLParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :league_participants, :mov, :integer
    add_column :league_participants, :score, :integer
  end
end
