# app/controllers/admin/counties_controller.rb
class Admin::CountiesController < Admin::BaseController
  before_action :set_county, only: %i[show edit update destroy]

  def index
    @counties = County.order(:name)
  end

  def show; end

  def new
    @county = County.new
  end

  def create
    @county = County.new(county_params)

    if @county.save
      redirect_to admin_counties_path, notice: "County created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @county.update(county_params)
      redirect_to admin_counties_path, notice: "County updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @county.destroy
    redirect_to admin_counties_path, notice: "County deleted"
  end

  private

  def set_county
    @county = County.find(params[:id])
  end

  def county_params
    params.require(:county).permit(:name, :cover_image)
  end
end
