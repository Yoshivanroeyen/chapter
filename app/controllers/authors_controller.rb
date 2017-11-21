class AuthorsController < ApplicationController
  skip_before_action :authenticate_registration!, only: [:show]
  before_action :set_author, only: [:show, :dashboard]
  skip_after_action :verify_authorized, only: :dashboard

# GET
def new
  @author = Author.new
  authorize @author

end

# POST
def create
  @author = Author.new(author_params)
  @author.user = current_user
  authorize @author

  if @author.save
      user_author
      redirect_to author_dashboard_path(current_author)
    else
     render :new
   end
 end

def show
authorize @author
end

def dashboard
  @books = current_author.books
  @selected_book = @books.where(title: params[:selected_book_reads])
  @my_transactions = current_author.transactions
  @book_transactions = @my_transactions.where(book: @selected_book)
  @book = @books.where(title: params[:selected_book_reviews])
  @my_reviews = []
  @books.each do |book|
    book.reviews.each do |review|
      @my_reviews << review
    end
  end
  @my_reviews.sort_by { |k| k[:updated_at] }
end

private

def author_params
  params.require(:author).permit(:nom_de_plume, :bank_account, :status, :user_id)
end

def set_author
  @author = params[:id] ? Author.find(params[:id]) : current_author
end

def user_author
  current_user.is_author = true
  current_user.save
end


end
