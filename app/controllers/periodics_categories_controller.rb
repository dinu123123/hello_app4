class PeriodicsCategoriesController < ApplicationController
  before_action :set_periodics_category, only: [:show, :edit, :update, :destroy]

  # GET /periodics_categories
  # GET /periodics_categories.json
  def index
    @periodics_categories = PeriodicsCategory.all
  end

  # GET /periodics_categories/1
  # GET /periodics_categories/1.json
  def show
  end

  # GET /periodics_categories/new
  def new
    @periodics_category = PeriodicsCategory.new
  end

  # GET /periodics_categories/1/edit
  def edit
  end

  # POST /periodics_categories
  # POST /periodics_categories.json
  def create
    @periodics_category = PeriodicsCategory.new(periodics_category_params)

    respond_to do |format|
      if @periodics_category.save
        format.html { redirect_to @periodics_category, notice: 'Periodics category was successfully created.' }
        format.json { render :show, status: :created, location: @periodics_category }
      else
        format.html { render :new }
        format.json { render json: @periodics_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /periodics_categories/1
  # PATCH/PUT /periodics_categories/1.json
  def update
    respond_to do |format|
      if @periodics_category.update(periodics_category_params)
        format.html { redirect_to @periodics_category, notice: 'Periodics category was successfully updated.' }
        format.json { render :show, status: :ok, location: @periodics_category }
      else
        format.html { render :edit }
        format.json { render json: @periodics_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /periodics_categories/1
  # DELETE /periodics_categories/1.json
  def destroy
    @periodics_category.destroy
    respond_to do |format|
      format.html { redirect_to periodics_categories_url, notice: 'Periodics category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_periodics_category
      @periodics_category = PeriodicsCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def periodics_category_params
      params.require(:periodics_category).permit(:name)
    end
end
