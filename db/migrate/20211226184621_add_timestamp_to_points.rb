class AddTimestampToPoints < ActiveRecord::Migration[6.0]
  def change
    add_column :points, :timestamp, :datetime
  end
end
