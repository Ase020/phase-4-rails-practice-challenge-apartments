class ApartmentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_apartment_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  wrap_parameters format: []
  def index
    apartments = Apartment.all
    render json: apartments, status: :ok
  end

  def show
    apartment = find_apartment
    render json: apartment, status: :ok
  end

  def create
    apartment = Apartment.create!(apartment_params)
    render json: apartment, status: :created
  end

  def update
    apartment = find_apartment
    apartment.update!(apartment_params)
    render json: apartment, status: :ok
  end

  def destroy
    apartment = find_apartment
    apartment.destroy!
    head :no_content
  end

  private
  def find_apartment
    Apartment.find(params[:id])
  end

  def apartment_params
    params.permit(:number)
  end

  def render_apartment_not_found
    render json: {error: "Apartment not found"}, status: :not_found
  end

  def render_unprocessable_entity(e)
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end
end
