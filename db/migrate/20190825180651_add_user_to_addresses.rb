class AddUserToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :user_id, :integer
    add_column :addresses, :prize_level, :integer, default: 0
  end
end
