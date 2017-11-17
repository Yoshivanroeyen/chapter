class BooksController < ApplicationController
  # The show method displays only further details on a single book
  # Find only the book that has the id defined in params[:id]
  skip_before_action :authenticate_registration!, only: [:index, :show, :search, :filter_genre]

  def show
   @book = Book.find(params[:id])
   @user = current_user
   @review = Review.new
  end

 def new
  @author = current_author
  @book = Book.new

 end

 def create
  @book = Book.new(book_params)
  @book.author_id = current_author.id
  if @book.save
    redirect_to author_dashboard_path
  else
    render :new
  end
 end

 def search
    # onder index te plaatsen
    Book.reindex
    @books = (params[:query].present?) ? Book.search(params[:query]) : Book.all
    sort_results(@books)
    @genres = []
    @books.each do |book|
      @genres << book.genre
    end
    @genres.uniq!
    return @books
  end

  def filter_genre
    search
    genre = params[:genre]
    @books = (params[:query].present?) ? Book.search(params[:query]) : Book.all
    @books = @books.where(genre: genre)
    sort_results(@books)
    @genres = []
    @books.each do |book|
      @genres << book.genre
    end
    @genres.uniq!
  end

  def index
    @books = Book.all
  end

  def buy
    @book = Book.find(params[:id])
  end


private

  def sort_results(data)
    @ordered_books = data.sort_by { |book| average_rating(book) }
    @ordered_books.reverse!
  end

  def average_rating(book)
    book.reviews.count != 0 ? @average_rating = book.reviews.average(:rating) : @average_rating = 0
  end

  def book_params
    params.require(:book).permit(:title, :description, :genre, :tags, :cover_pic, :cover_pic_cache, :quote_hover)
  end

end
