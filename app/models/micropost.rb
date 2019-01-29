class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  mount_uploader :picture, PictureUploader
  scope :order_desc, ->{order created_at: :desc}
  validate :picture_size

   private

  def picture_size
    return unless picture.size > 5.megabytes
    errors.add :picture, Micropost.human_attribute_name("image_error")
  end
end
