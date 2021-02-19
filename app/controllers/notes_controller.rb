class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  def index
    @notes = current_user.notes.paginate(page: params.fetch(:page, 1), per_page: params.fetch(:per_page, 10))
  end

  # GET /notes/1
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  def create
    @note = Note.new(note_params)
    @note.user = current_user
    if @note.book.blank?
      @note.book = current_user.books.where(title: "Global Book").first
    end
    
    if @note.save
      redirect_to @note, notice: 'Note was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /notes/1
  def update
    new_values = note_params
    if new_values[:book_id].blank?
      new_values[:book_id] = current_user.books.where(title: "Global Book").select("id").first.id
    end
    if @note.update(new_values)
      redirect_to @note, notice: 'Note was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
    redirect_to notes_url, notice: 'Note was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:book_id, :title, :content, :user_id)
    end
end
