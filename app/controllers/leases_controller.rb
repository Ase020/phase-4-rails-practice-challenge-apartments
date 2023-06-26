class LeasesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_lease_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  wrap_parameters format: []

  def index
    leases = Lease.all
    render json: leases, status: :ok
  end

  def create
    lease = Lease.create!(lease_params)
    tenant = lease.tenant
    render json: tenant, status: :created
  end

  def destroy
    lease = find_lease
    lease.destroy
    head :no_content
  end

  private
  def find_lease
    Lease.find(params[:id])
  end

  def lease_params
    params.permit(:rent, :apartment_id, :tenant_id)
  end

  def render_lease_not_found
    render json: {error: "Lease not found"}, status: :not_found
  end

  def render_unprocessable_entity(e)
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end
end
