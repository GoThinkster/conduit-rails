class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, uniqueness: true, presence: true, allow_blank: false

  has_many :articles
  has_many :favorites

  def generate_jwt
    JWT.encode({ id: self.id,
                 username: self.username,
                 exp: 60.days.from_now.to_i },
               Rails.application.secrets.secret_key_base)
  end

  def favorited?(article)
    favorites.find_by(article_id: article.id).present?
  end

  def favorite(article)
    favorites.find_or_create_by(article: article)
  end

  def unfavorite(article)
    favorites.where(article: article).destroy_all
  end
end
