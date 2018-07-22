class GermanyTollsController < ApplicationController
def index
    @germany_tolls = GermanyToll.all
  end


  def import
    GermanyToll.import(params[:file])
    redirect_to root_url, notice: "Activity Data Imported!"
  end 
end
