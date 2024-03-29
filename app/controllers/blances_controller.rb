class BlancesController < ApplicationController
  def index
    @blances = Blance.all
  end

  def show
    @blance = Blance.find(params[:id])
  end

  def new
    @blance = Blance.new
  end

  def edit
    @blance = Blance.find(params[:id])
  end

  def create
    @blance = Blance.new(blance_params)
    if @blance.save
      redirect_to @blance, notice: t(".notice")
    else
      @blance.images = nil
      render("new", status: :bad_request)
    end
  end

  def update
    @blance = Blance.find(params[:id])
    if @blance.update(blance_params)
      redirect_to @blance, notice: t(".notice")
    else
      @blance.reload
      render("edit", status: :bad_request)
    end
  end

  def destroy
    @blance = Blance.find(params[:id])
    @blance.destroy
    redirect_to blances_url, notice: t(".notice")
  end

  private

  def blance_params
    params.require(:blance).permit(
      :date,
      :category,
      :machine_name,
      :investment_money,
      :recovery_money,
      :investment_saving,
      :recovery_saving,
      :rate,
      :store,
      :note,
      images: []
    )
  end
end
