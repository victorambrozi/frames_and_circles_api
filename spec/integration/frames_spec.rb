require 'swagger_helper'

RSpec.describe 'Frames API', type: :request do
  path '/frames' do
    post 'Creates a frame' do
      tags 'Frames'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :frame, in: :body, schema: {
        type: :object,
        properties: {
          frame: {
            type: :object,
            properties: {
              x: { type: :number, example: 100.0 },
              y: { type: :number, example: 100.0 },
              width: { type: :number, example: 200.0 },
              height: { type: :number, example: 200.0 },
              circles_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    x: { type: :number },
                    y: { type: :number },
                    diameter: { type: :number }
                  }
                }
              }
            },
            required: %w[x y width height]
          }
        }
      }

      response '201', 'Frame created' do
        let(:frame) { { frame: { x: 100, y: 100, width: 200, height: 200 } } }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:frame) { { frame: { x: nil } } }
        run_test!
      end
    end
  end

  path '/frames/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a frame with metrics' do
      tags 'Frames'
      produces 'application/json'

      response '200', 'Frame found' do
        let(:frame) { create(:frame) }
        let(:id) { frame.id }
        
        before do
          create(:circle, frame: frame, x: frame.x - frame.width/2 + 20, y: frame.y, diameter: 20)
          create(:circle, frame: frame, x: frame.x + frame.width/2 - 20, y: frame.y, diameter: 20)
        end
        
        run_test!
      end
    end

    delete 'Deletes a frame' do
      tags 'Frames'
      
      response '204', 'Frame deleted' do
        let(:id) { create(:frame).id }
        run_test!
      end

      response '422', 'Frame with circles cannot be deleted' do
        let(:frame) { create(:frame) }
        let(:id) { frame.id }
        
        before do
          create(:circle, 
                frame: frame,
                x: frame.x - frame.width/2 + 20,
                y: frame.y - frame.height/2 + 20,
                diameter: 20)
        end
        
        run_test!
      end
    end
  end
end