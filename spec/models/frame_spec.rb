require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe 'geometric validations' do
    context 'when not touching other frames' do
      it 'is valid with sufficient spacing' do
        create(:frame, x: 0, y: 0, width: 100, height: 100)
        frame2 = build(:frame, x: 150, y: 0, width: 100, height: 100)
        expect(frame2).to be_valid
      end
    end

    context 'when touching or overlapping' do
      before { create(:frame, x: 0, y: 0, width: 100, height: 100) }

      it 'is invalid when touching edges' do
        frame2 = build(:frame, x: 100, y: 0, width: 100, height: 100) # Toca na borda direita
        expect(frame2).not_to be_valid
      end

      it 'is invalid when overlapping' do
        frame2 = build(:frame, x: 50, y: 50, width: 100, height: 100) # Sobreposição parcial
        expect(frame2).not_to be_valid
      end
    end
  end
end