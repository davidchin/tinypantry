class Bookmark < ActiveRecord::Base
  belongs_to :recipe, counter_cache: true, touch: true
  belongs_to :user

  validates :user_id, presence: true
  validates :recipe_id, presence: true, uniqueness: { scope: :user_id }
end
