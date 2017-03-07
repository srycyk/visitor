
class BookmarksController < TagTreeController
  before_action :set_tag

  before_action :set_bookmark, only: [:show, :edit, :update, :destroy]

  # GET /bookmarks
  # GET /bookmarks.json
  def index
    @bookmarks = BookmarkLister.new(@tag)
                               .(query: params[:q], by: params[:by]).to_a
  end

  # GET /bookmarks/1
  # GET /bookmarks/1.json
  def show
    #respond_to {|format| format.json { render json: @bookmark, status: :ok } }
  end

  # GET /bookmarks/new
  def new
    @bookmark = @tag.bookmarks.new
  end

  # GET /bookmarks/1/edit
  def edit
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    @bookmark = @tag.bookmarks.new(bookmark_params)

    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to path_for_redirect, notice: "Bookmark, #@bookmark created." }

        format.json { render json: @bookmark, status: :created }
      else
        format.html { render :new }

        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookmarks/1
  # PATCH/PUT /bookmarks/1.json
  def update
    respond_to do |format|
      @bookmark.user = current_user # To check if changed tag is user's own
      if @bookmark.update(bookmark_params)
        format.html { redirect_to path_for_redirect, notice: "Bookmark, #@bookmark updated." }

        format.js { @bookmarks = BookmarkLister.new(@bookmark.reload.tag).() ; render :index }

        format.json { render json: @bookmark, status: :ok }
      else
        format.html { render :edit }

        format.js { render :edit }

        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy
    @bookmark.destroy
    respond_to do |format|
      format.html { redirect_to [@tag, :bookmarks], notice: "Bookmark, #@bookmark deleted." }

      format.json { head :no_content }
    end
  end

  private

  def set_tag
    tag_id = params[:tag_id] || params.dig(:bookmark, :tag_id)

    @tag = current_user.tags.find_by id: tag_id
  end

  def set_bookmark
    @bookmark = @tag.bookmarks.find(params[:id])
  end

  def path_for_redirect
    [ @bookmark.reload.tag || @tag, @bookmark ] # reload in case tag is changed
  end

  def bookmark_params
    params.require(:bookmark).permit(:url, :title, :description, :tag_id)
  end
end
