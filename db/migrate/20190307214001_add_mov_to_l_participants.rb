class AddMovToLParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :league_participants, :mov, :integer
    add_column :league_participants, :wins, :integer
  end
end
