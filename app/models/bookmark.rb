class Bookmark < ActiveRecord::Base
  belongs_to :recipe, counter_cache: true
  belongs_to :user

  validates :user_id, presence: true
  validates :recipe_id, presence: true
end
