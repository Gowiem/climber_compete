class ChangeLatestClimbIdName < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :latest_climb_id, :latest_climb_route_id
  end
end
