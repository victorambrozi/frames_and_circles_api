class Circle < ApplicationRecord
  belongs_to :frame
  
  validates :x, :y, :diameter, presence: true
  validates :x, :y, numericality: true
  validates :diameter, numericality: { greater_than: 0 }

  validate :validate_inside_frame
  validate :validate_circle_isolation
  
  def validate_inside_frame
    return if frame.blank?

    radius = diameter / 2.to_f

    top = y - radius
    right = x + radius
    bottom = y + radius
    left = x - radius

    if left < frame.left || right > frame.right || top < frame.top || bottom > frame.bottom
      errors.add(:base, "Circle should be completely within the frame")
    end
  end

  def validate_circle_isolation
    return unless frame && diameter && x && y

    frame.circles.where.not(id: id).each do |other_circle|
      distance_x = x - other_circle.x
      distance_y = y - other_circle.y
      distance_squared = distance_x**2 + distance_y**2 # prevent comparing errors
      
      sum_radii = (diameter + other_circle.diameter) / 2.to_f
      min_distance_squared = sum_radii**2

      if distance_squared <= min_distance_squared
        errors.add(:base, "Circle is touching or overlapping another circle in the same frame")
        break
      end
    end
  end
end
