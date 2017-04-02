class AddLatestClimbFieldsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :latest_climb_date, :datetime
    add_column :users, :latest_climb_id, :string
  end
end
