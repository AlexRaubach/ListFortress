class CreateRoundtypes < ActiveRecord::Migration[5.2]
  def change
    create_table :roundtypes do |t|
      t.string :name

      t.timestamps
    end
    
    Roundtype.create(name:'swiss')
    Roundtype.create(name:'elimination')
  end
end
