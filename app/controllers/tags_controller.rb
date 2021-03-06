
class TagsController < TagTreeController
  before_action :set_tag, only: %i(show edit update destroy)

  # GET /tags
  # GET /tags.json
  def index
    lister = TagLister.new(current_user)

    @tags = lister.(query: params[:q], tag_id: params[:tag_id])

    # @tag forces menu expansion and a subtitle to appear
    @tag = lister.tag
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new tag_id: params[:tag_id]
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = current_user.tags.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to :tags, notice: "Tag, #{@tag} created." }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to :tags, notice: "Tag, #{@tag} updated." }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag.expunge

    respond_to do |format|
      format.html { redirect_to :tags, notice: "Tag, #{@tag} deleted." }
      format.json { head :no_content }
    end
  end

  private

  def set_tag
    @tag = current_user.tags.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :title, :tag_id)
  end
end
