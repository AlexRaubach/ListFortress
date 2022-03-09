class AddSortToFormat < ActiveRecord::Migration[6.1]
  def change
    add_column :formats, :sort, :integer
  end
end
