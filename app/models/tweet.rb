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

  has_one_attached :featured_image
  has_rich_text :body
  validates :body, presence: true
end
