class HashtagsController < ApplicationController
  before_action :set_hashtag, only: [:show, :edit, :update, :destroy]

  # GET /hashtags
  # GET /hashtags.json
  def index
    @hashtags = Hashtag.all
  end

  # GET /hashtags/1
  # GET /hashtags/1.json
  def show
  end

  # GET /hashtags/new
  def new
    @hashtag = Hashtag.new
  end

  # GET /hashtags/1/edit
  def edit
  end

  # POST /hashtags
  # POST /hashtags.json
  def create
    @hashtag = Hashtag.new(hashtag_params)

    respond_to do |format|
      if @hashtag.save
        format.html { redirect_to @hashtag, notice: 'Hashtag was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hashtag }
      else
        format.html { render action: 'new' }
        format.json { render json: @hashtag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hashtags/1
  # PATCH/PUT /hashtags/1.json
  def update
    respond_to do |format|
      if @hashtag.update(hashtag_params)
        format.html { redirect_to @hashtag, notice: 'Hashtag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hashtag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hashtags/1
  # DELETE /hashtags/1.json
  def destroy
    @hashtag.destroy
    respond_to do |format|
      format.html { redirect_to hashtags_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hashtag
      @hashtag = Hashtag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hashtag_params
      params.require(:hashtag).permit(:content)
    end
end
