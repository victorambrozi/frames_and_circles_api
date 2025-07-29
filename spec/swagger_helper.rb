require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.to_s + '/swagger'

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Frames and Circles API',
        version: 'v1',
        description: 'API for registration and management of frames and associated circles, obeying geometric rules of positioning and spatial limitation.'
      },
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {
        schemas: {
          frame: {
            type: :object,
            properties: {
              id: { type: :integer },
              x: { type: :number, format: :float },
              y: { type: :number, format: :float },
              width: { type: :number, format: :float },
              height: { type: :number, format: :float }
            }
          },
          circle: {
            type: :object,
            properties: {
              id: { type: :integer },
              x: { type: :number, format: :float },
              y: { type: :number, format: :float },
              diameter: { type: :number, format: :float },
              frame_id: { type: :integer }
            }
          }
        }
      }
    }
  }

  config.swagger_format = :yaml
end