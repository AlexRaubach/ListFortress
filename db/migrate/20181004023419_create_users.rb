class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.boolean :league_eligible
      t.string :slack_name
      t.string :slack_email
      t.string :slack_avatar

      t.timestamps
    end
  end
end
