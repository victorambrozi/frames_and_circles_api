class CirclesController < ApplicationController
  before_action :set_circle, only: [:update, :destroy]

  def index
    circles = Circle.all
    circles = circles.where(frame_id: params[:frame_id]) if params[:frame_id]
    
    if params[:center_x] && params[:center_y] && params[:radius]
      circles = filter_circles_in_radius(circles)
    end
    
    render json: circles
  end

  def create
    @circle = Circle.new(circle_params)
    
    if @circle.save
      render json: @circle, status: :created
    else
      render json: @circle.errors, status: :unprocessable_entity
    end
  end

  def update
    if @circle.update(circle_params)
      render json: @circle
    else
      render json: @circle.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @circle.destroy
    head :no_content
  end

  private

  def set_circle
    @circle = Circle.find(params[:id])
  end

  def circle_params
    params.require(:circle).permit(:x, :y, :diameter, :frame_id)
  end

  def filter_circles_in_radius(circles)
    center_x = params[:center_x].to_f
    center_y = params[:center_y].to_f
    radius = params[:radius].to_f
    
    circles.select do |circle|
      distance = Math.sqrt((circle.x - center_x)**2 + (circle.y - center_y)**2)
      (distance + circle.diameter/2.0) <= radius
    end
  end
end