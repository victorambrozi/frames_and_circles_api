require 'rails_helper'

RSpec.describe "API Endpoints", type: :request do
  let(:frame) { create(:frame, x: 100, y: 100, width: 200, height: 200) }
  let(:circle) { create(:circle, frame: frame, x: 110, y: 110, diameter: 20) }

  describe "POST /frames" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          frame: {
            x: 300,
            y: 300,
            width: 200,
            height: 200,
            circles_attributes: [
              { x: 310, y: 310, diameter: 20 }
            ]
          }
        }
      end

      it "creates a new frame" do
        expect {
          post "/frames", params: valid_params
        }.to change(Frame, :count).by(1)
        
        expect(response).to have_http_status(:created)
        expect(json_response['x'].to_f).to eq(300)
      end
    end

    context "with invalid parameters" do
      it "returns 422 for invalid data" do
        post "/frames", params: { frame: { x: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /frames/:frame_id/circles" do
    let(:frame) { create(:frame, x: 500, y: 500, width: 1000, height: 1000) }

    context "with valid parameters" do
      let(:circle_params) do
        {
          circle: {
            x: 510,
            y: 510,
            diameter: 20,
            frame_id: frame.id
          }
        }
      end

      it "creates a new circle in frame" do
        expect {
          post "/frames/#{frame.id}/circles", params: circle_params
        }.to change { frame.circles.reload.count }.by(1)
        
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe "PUT /circles/:id" do
    before { circle }

    context "with valid parameters" do
      it "updates circle position" do
        put "/circles/#{circle.id}", 
            params: { circle: { x: 115, y: 115 } }
        
        expect(response).to have_http_status(:ok)
        expect(json_response['x'].to_f).to eq(115)
      end
    end

    context "with invalid parameters" do
      it "returns 422 for invalid position" do
        put "/circles/#{circle.id}", 
            params: { circle: { x: 500, y: 500 } }
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /circles" do
    before do
      frame.circles.destroy_all
      create(:circle, frame: frame, x: 110, y: 110, diameter: 20)
      create(:circle, frame: frame, x: 140, y: 140, diameter: 20)
      create(:circle, frame: frame, x: 170, y: 170, diameter: 20)
    end

    it "returns circles within radius" do
      get "/circles", params: { center_x: 110, center_y: 110, radius: 50 }
      
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
    end

    it "filters by frame_id" do
      get "/circles", params: { frame_id: frame.id }
      
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(3)
    end
  end

  describe "GET /frames/:id" do
    before do
      create(:circle, frame: frame, x: 90, y: 90, diameter: 10)
      create(:circle, frame: frame, x: 110, y: 110, diameter: 10)
    end

    it "returns frame with metrics" do
      get "/frames/#{frame.id}"
      
      expect(response).to have_http_status(:ok)
      expect(json_response['metrics']['total_circles']).to eq(2)
      expect(json_response['metrics']['leftmost_point'].to_f).to eq(90)
      expect(json_response['metrics']['rightmost_point'].to_f).to eq(110)
    end
  end

  describe "DELETE /circles/:id" do
    it "deletes a circle" do
      delete "/circles/#{circle.id}"
      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 for invalid id" do
      delete "/circles/999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /frames/:id" do
    let!(:frame) { create(:frame, x: 50, y: 50, width: 100, height: 100) }

    context "when frame has circles" do
      before do
        create(:circle, frame: frame, x: 30, y: 30, diameter: 10)
        create(:circle, frame: frame, x: 45, y: 30, diameter: 10)
      end

      it "returns 422 unprocessable entity" do
        expect {
          delete "/frames/#{frame.id}"
        }.not_to change(Frame, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq("Frame has associated circles")
      end
    end

    context "when frame has no circles" do
      it "returns 204 no content" do
        expect {
          delete "/frames/#{frame.id}"
        }.to change(Frame, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end