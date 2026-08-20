class Tweet < ApplicationRecord
  belongs_to :parent,
             class_name: "Tweet",
             optional: true,
             inverse_of: :children

  has_many :children,
           class_name: "Tweet",
           foreign_key: :parent_id,
           inverse_of: :parent,
           dependent: :nullify

  scope :main_tweets, -> { where(parent_id: nil) }
  has_one_attached :featured_image
  has_rich_text :body
  validates :body, presence: true
  validate :body_plain_text_length

  private
  # additional stuff for rich_text
  def body_plain_text_length
    return unless body&.to_plain_text&.length.to_i > 200

    errors.add(:body, :too_long, count: 200)
  end
end
