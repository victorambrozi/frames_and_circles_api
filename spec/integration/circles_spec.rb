require 'swagger_helper'

RSpec.describe 'Circles API', type: :request do
  path '/frames/{frame_id}/circles' do
    parameter name: :frame_id, in: :path, type: :integer

    post 'Creates a circle in frame' do
      tags 'Circles'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          circle: {
            type: :object,
            properties: {
              x: { type: :number },
              y: { type: :number },
              diameter: { type: :number }
            },
            required: %w[x y diameter]
          }
        }
      }

      response '201', 'circle created' do
        let(:frame_id) { create(:frame).id }
        let(:circle) { { circle: { x: 110, y: 110, diameter: 20 } } }
        run_test!
      end

      response '422', 'invalid circle' do
        let(:frame_id) { create(:frame).id }
        let(:circle) { { circle: { x: 500, y: 500, diameter: 20 } } }
        run_test!
      end
    end
  end

  path '/circles/{id}' do
    parameter name: :id, in: :path, type: :integer

    put 'Updates a circle' do
      tags 'Circles'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          circle: {
            type: :object,
            properties: {
              x: { type: :number },
              y: { type: :number }
            }
          }
        }
      }

      response '200', 'circle updated' do
        let(:circle) { create(:circle) }
        let(:id) { circle.id }
        let(:circle_params) { { circle: { x: 115, y: 115 } } }
        run_test!
      end

      response '422', 'invalid update' do
        let(:circle) { create(:circle) }
        let(:id) { circle.id }
        let(:circle_params) { { circle: { x: 500, y: 500 } } }
        run_test!
      end
    end

    delete 'Deletes a circle' do
      tags 'Circles'
      
      response '204', 'circle deleted' do
        let(:id) { create(:circle).id }
        run_test!
      end

      response '404', 'circle not found' do
        let(:id) { 999 }
        run_test!
      end
    end
  end

  path '/circles' do
    get 'Searches circles' do
      tags 'Circles'
      produces 'application/json'

      parameter name: :center_x, in: :query, type: :number
      parameter name: :center_y, in: :query, type: :number
      parameter name: :radius, in: :query, type: :number
      parameter name: :frame_id, in: :query, type: :integer

      response '200', 'circles found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              x: { type: :number },
              y: { type: :number },
              diameter: { type: :number },
              frame_id: { type: :integer }
            }
          }

        let(:frame) { create(:frame) }
        let(:frame_id) { frame.id }
        before { create(:circle, frame: frame) }
        
        run_test!
      end
    end
  end
end