class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :destroy, :show]

  def index
    if params[:q]
      @params = params[:q]

      # делаем доступные параметры фильтров, чтобы их поместить их в параметр q «кнопки создать csv по фильтру»
      @params_q_to_csv = @params.permit(
        :title_or_sku_cont,
        :check_eq,
        :vendor_eq,
        :quantity_eq,
        :quantity_not_eq,
        :price_gteq,
        :price_lteq,
        :insales_check_eq,
        :quantity_insales_eq,
      )
    else
      @params = []
    end

    @search = Product.ransack(@params)
    @search.sorts = 'id desc' if @search.sorts.empty?

    # данные для «кнопки создать csv по фильтру», все данные в отличии от @products, который ограничен 100
    if @params.present?
      @search_id_by_q = Product.ransack(@params_q_to_csv)
    else
      @search_id_by_q = Product.all
    end

    @products = @search.result.paginate(page: params[:page], per_page: 100)

    if params['otchet_type'] == 'csv_selected'
      CreateCsvSelectedJob.perform_later(@search_id_by_q.result.pluck(:id))
      # Services::CreateCsvSelected.new(@search_id_by_q.result.pluck(:id)).call
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Запущено создание Сsv Selected' }
        format.json { render json: {status: "okey", message: "Запущено создание Сsv Selected"} }
      end
    end

  end

  def show; end

  def destroy
    if @product.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  def dpo_update
    DpoUpdateJob.perform_later
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Запущен апдейт товаров от апоставщика Dpo' }
      format.json { render json: {status: "okey", message: "Запущен апдейт товаров от апоставщика Dpo"} }
    end
  end

  def import_insales_xml
    ImportInsalesXmlJob.perform_later
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Запущен апдейт товаров из Insales' }
      format.json { render json: {status: "okey", message: "Запущен апдейт товаров из Insales"} }
    end
  end

  def api_insales_update
    ApiInsalesUpdateJob.perform_later
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Запущено по API обновление в магазине' }
      format.json { render json: {status: "okey", message: "Запущено по API обновление в магазине"} }
    end
  end

  # def create_csv_price
  #   CreateCsvPriceJob.perform_later
  #   respond_to do |format|
  #     format.html { redirect_to products_url, notice: 'Запущено создание Сsv Price' }
  #     format.json { render json: {status: "okey", message: "Запущено создание Сsv Price"} }
  #   end
  # end
  #
  # def create_csv_quantity
  #   CreateCsvQuantityJob.perform_later
  #   respond_to do |format|
  #     format.html { redirect_to products_url, notice: 'Запущено создание Сsv Quantity' }
  #     format.json { render json: {status: "okey", message: "Запущено создание Сsv Quantity"} }
  #   end
  # end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
