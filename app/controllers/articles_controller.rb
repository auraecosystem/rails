class ArticlesController < ApplicationController
  def index
    @articles = Article.recent
  end

  def show
    @article = Article.find(params[:id])
    fresh_when etag: @article
  end

  def create
    article = Article.create!(article_params)
    redirect_to article
  end

  private
    def article_params
      params.expect(article: [ :title, :content ])
    end
end
