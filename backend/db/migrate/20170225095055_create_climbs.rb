class CreateClimbs < ActiveRecord::Migration[5.0]
  def change
    create_table :climbs do |t|
      t.string :name
      t.datetime :climb_date
      t.string :rating
      t.integer :pitches
      t.string :route_id
      t.string :type
      t.integer :user_id

      t.timestamps
    end
  end
end
