class CreateTournaments < ActiveRecord::Migration[5.2]
  def change
    create_table :tournaments do |t|

      t.timestamps
    end
  end
end
