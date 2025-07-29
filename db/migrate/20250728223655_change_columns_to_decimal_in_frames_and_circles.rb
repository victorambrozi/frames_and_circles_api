class ChangeColumnsToDecimalInFramesAndCircles < ActiveRecord::Migration[8.0]
  def change
    change_column :frames, :x, :decimal, precision: 8, scale: 2
    change_column :frames, :y, :decimal, precision: 8, scale: 2
    change_column :frames, :width, :decimal, precision: 8, scale: 2
    change_column :frames, :height, :decimal, precision: 8, scale: 2

    change_column :circles, :x, :decimal, precision: 8, scale: 2
    change_column :circles, :y, :decimal, precision: 8, scale: 2
    change_column :circles, :diameter, :decimal, precision: 8, scale: 2
  end
end
