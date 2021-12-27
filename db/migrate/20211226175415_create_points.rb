class CreatePoints < ActiveRecord::Migration[6.0]
  def change
    create_table :points do |t|
      t.string :payer
      t.integer :points

      t.timestamps
    end
  end
end
