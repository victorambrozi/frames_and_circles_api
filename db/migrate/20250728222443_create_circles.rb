class CreateCircles < ActiveRecord::Migration[8.0]
  def change
    create_table :circles do |t|
      t.integer :x
      t.integer :y
      t.integer :diameter
      t.references :frame, null: false, foreign_key: true

      t.timestamps
    end
  end
end
