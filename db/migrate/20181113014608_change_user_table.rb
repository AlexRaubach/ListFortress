class ChangeUserTable < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :slack_id
      t.boolean :league_eligible
      t.string :name
      t.string :slack_avatar
      t.boolean :admin
      t.remove :provider
      t.remove :uid

    end
  end
end
