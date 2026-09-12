class Article < ApplicationRecord
  belongs_to :author, default: -> { Current.user }
  has_many   :comments

  has_one_attached :cover_image
  has_rich_text :content, encrypted: true
  enum status: %i[ drafted published ]

  scope :recent, -> { order(created_at: :desc).limit(25) }

  after_save_commit :deliver_later, if: :published?

  def byline
    "Written by #{author.name} on #{created_at.to_s(:short)}"
  end

  def deliver_later
    Article::DeliveryJob.perform_later(self)
  end
end
