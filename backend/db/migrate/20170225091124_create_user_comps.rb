class CreateUserComps < ActiveRecord::Migration[5.0]
  def change
    create_table :user_comps do |t|

      t.timestamps
    end
  end
end
