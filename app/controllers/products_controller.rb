class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  def who_bought
    @product = Product.find(params[:id])
    @latest_order = @product.orders.order(:updated_at).last
    if stale?(@latest_order)
      respond_to do |format|
        format.atom
        format.html
        format.xml {  render xml: @product.to_xml(:only => [:id, :title], 
                                                  :include => {
                                                    :orders => { #<==== new association
                                                      :only => [:id, :name, :address, :pay_type, :created_at], 
                                                      :include => {
                                                        :line_items => { #<==== new association
                                                          :only => [ :id, :product_id, :cart_id ]
                                                        }
                                                      }
                                                    }
                                                  }
                                                )}
        format.json {  render json: @product.to_json(:only => [:id, :title], 
                                                  :include => {
                                                    :orders => { #<==== new association
                                                      :only => [:id, :name, :address, :pay_type, :created_at], 
                                                      :include => {
                                                        :line_items => { #<==== new association
                                                          :only => [ :id, :product_id, :cart_id ]
                                                        }
                                                      }
                                                    }
                                                  }
                                                )}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price)
    end
end
