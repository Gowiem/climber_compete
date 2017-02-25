class AddColumnToUserComp < ActiveRecord::Migration[5.0]
  def change
    add_column :user_comps, :user_id, :integer
    add_column :user_comps, :competition_id, :integer
  end
end
