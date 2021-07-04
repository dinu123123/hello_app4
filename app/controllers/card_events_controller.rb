class CardEventsController < ApplicationController
  before_action :set_card_event, only: [:show, :edit, :update, :destroy]

  # GET /card_events
  # GET /card_events.json
  def index
    @card_events = CardEvent.all
    @trucks = Truck.all
    @cards = Card.all
  end

  # GET /card_events/1
  # GET /card_events/1.json
  def show
  end

  # GET /card_events/new
  def new
    @card_event = CardEvent.new
  end

  # GET /card_events/1/edit
  def edit
  end

  # POST /card_events
  # POST /card_events.json
  def create
    @card_event = CardEvent.new(card_event_params)

    respond_to do |format|
      if @card_event.save
        format.html { redirect_to @card_event, notice: 'Card event was successfully created.' }
        format.json { render :show, status: :created, location: @card_event }
      else
        format.html { render :new }
        format.json { render json: @card_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /card_events/1
  # PATCH/PUT /card_events/1.json
  def update
    respond_to do |format|
      if @card_event.update(card_event_params)
        format.html { redirect_to @card_event, notice: 'Card event was successfully updated.' }
        format.json { render :show, status: :ok, location: @card_event }
      else
        format.html { render :edit }
        format.json { render json: @card_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /card_events/1
  # DELETE /card_events/1.json
  def destroy
    @card_event.destroy
    respond_to do |format|
      format.html { redirect_to card_events_url, notice: 'Card event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card_event
      @card_event = CardEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_event_params
      params.require(:card_event).permit(:date, :truck_id, :card_id)
    end
end
