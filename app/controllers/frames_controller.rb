class FramesController < ApplicationController
  before_action :set_frame, only: [:show, :destroy]

  def create
    @frame = Frame.new(frame_params)
    
    if @frame.save
      render json: @frame, status: :created
    else
      render json: @frame.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: {
      frame: @frame,
      metrics: {
        total_circles: @frame.circles.count,
        highest_point: @frame.circles.minimum(:y),
        lowest_point: @frame.circles.maximum(:y),
        leftmost_point: @frame.circles.minimum(:x),
        rightmost_point: @frame.circles.maximum(:x)
      }
    }
  end

  def destroy
    if @frame.circles.any?
      render json: { error: "Frame has associated circles" }, status: :unprocessable_entity
    else
      @frame.destroy
      head :no_content
    end
  end

  private

  def set_frame
    @frame = Frame.find(params[:id])
  end

  def frame_params
    params.require(:frame).permit(:x, :y, :width, :height)
  end
end