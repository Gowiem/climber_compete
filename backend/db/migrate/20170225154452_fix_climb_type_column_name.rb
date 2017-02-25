class FixClimbTypeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :climbs, :type, :climb_type
  end
end
