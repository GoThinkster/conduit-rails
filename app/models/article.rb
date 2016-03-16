class Article < ActiveRecord::Base
  belongs_to :user

  scope :authored_by, ->(username) { where(user: User.where(username: username)) }

  acts_as_taggable

  validates :title, presence: true,
                    allow_blank: false,
                    exclusion: { in: ['feed'] }
  validates :body, presence: true,
                   allow_blank: false
  validates :slug, uniqueness: true

  before_validation do
    self.slug = self.title.to_s.parameterize
  end
end
