class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, uniqueness: true, presence: true, allow_blank: false

  def generate_jwt
    JWT.encode({ id: self.id,
                 username: self.username,
                 exp: 60.days.from_now.to_i },
               Rails.application.secrets.secret_key_base)
  end
end
