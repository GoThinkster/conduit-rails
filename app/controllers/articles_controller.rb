class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @articles = Article.all.includes(:user)

    @articles = @articles.authored_by(params[:author]) if params[:author].present?

    @articles_count = @articles.count

    @articles = @articles.order(created_at: :desc).offset(params[:offset] || 0).limit(params[:limit] || 20)
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user

    unless @article.save
      render json: { errors: @article.errors }, status: :unprocessable_entity
    end
  end

  def show
    @article = Article.find_by_slug!(params[:slug])
  end

  def update
    @article = Article.find_by_slug!(params[:slug])

    if @article.user_id == @current_user_id
      @article.update_attributes(article_params)
    else
      render json: { errors: { article: ['not owned by user'] } }, status: :forbidden
    end
  end

  def destroy
    @article = Article.find_by_slug!(params[:slug])

    if @article.user_id == @current_user_id
      @article.destroy

      render json: {}
    else
      render json: { errors: { article: ['not owned by user'] } }, status: :forbidden
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :description)
  end
end
