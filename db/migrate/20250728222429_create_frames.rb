class CreateFrames < ActiveRecord::Migration[8.0]
  def change
    create_table :frames do |t|
      t.integer :x
      t.integer :y
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
