class AddRoundTypes < ActiveRecord::Migration[5.2]
  def up
    Roundtype.create(name:'swiss')
    Roundtype.create(name:'elimination')
  end
end
