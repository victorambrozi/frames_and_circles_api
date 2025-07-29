class Frame < ApplicationRecord
  has_many :circles, dependent: :destroy
  
  validates :x, :y, :width, :height, presence: true
  validates :x, :y, numericality: true
  validates :width, :height, numericality: { greater_than: 0 }

  validate :validate_not_touching_other_frames

  def left
    x - (width / 2.to_f)
  end

  def right
    x + (width / 2.to_f)
  end

  def top
    y - (height / 2.to_f)
  end

  def bottom
    y + (height / 2.to_f)
  end

  def validate_not_touching_other_frames
    Frame.where.not(id: id).each do |other|
      if touching_or_overlapping?(self, other)
        errors.add(:base, "Frame is playing or overlapping another frame")
        break
      end
    end
  end

  private

  def touching_or_overlapping?(current, other)
    !(self.right < other.left || self.left > other.right || self.bottom < other.top || self.top > other.bottom)
  end
end
