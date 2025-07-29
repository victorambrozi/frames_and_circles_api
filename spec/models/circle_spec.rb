require 'rails_helper'

RSpec.describe Circle, type: :model do
  let(:frame) { create(:frame, x: 50, y: 50, width: 100, height: 100) }

  describe 'geometric validations' do
    context 'when inside frame' do
      it 'is valid when not touching edges' do
        circle = build(:circle, frame: frame, x: 50, y: 50, diameter: 80)
        expect(circle).to be_valid
      end

      it 'is valid when touching edges but not crossing' do
        circle = build(:circle, frame: frame, x: 10, y: 50, diameter: 20)
        expect(circle).to be_valid
      end
    end

    context 'when outside frame' do
      it 'is invalid when crossing any edge' do
        circle = build(:circle, frame: frame, x: 5, y: 50, diameter: 20)
        expect(circle).not_to be_valid
      end
    end

    context 'when interacting with other circles' do
      before { create(:circle, frame: frame, x: 30, y: 50, diameter: 20) }

      it 'is invalid when touching another circle' do
        circle = build(:circle, frame: frame, x: 50, y: 50, diameter: 20)
        expect(circle).not_to be_valid
      end

      it 'is invalid when overlapping another circle' do
        circle = build(:circle, frame: frame, x: 35, y: 50, diameter: 20)
        expect(circle).not_to be_valid
      end
    end
  end
end