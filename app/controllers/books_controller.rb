class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy, :export]


#raise ActiveRecord::NotFound

  # GET /books
  def index
    @books = current_user.books
  end

  # GET /books/1
  def show
    if !current_user.books.include? @book
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  def create
    @book = Book.new(book_params)
    @book.user = current_user

    if @book.save
      redirect_to @book, notice: 'Book was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /books/1
  def destroy
    if @book.global?
      @book.delete_all_notes
    else
      @book.destroy
    end
    redirect_to books_url, notice: 'Book was successfully deleted.'
  end

  def global
    @notes = get_global_book_notes
  end

  # GET /export/1
  def export
    send_data(@book.export, :type => 'application/zip', :filename => "#{@book.title}.zip")
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title)
    end

    def get_global_book_notes
      current_user.notes.where(book: nil).all
    end
end
