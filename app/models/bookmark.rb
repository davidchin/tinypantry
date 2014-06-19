class Bookmark < ActiveRecord::Base
  belongs_to :recipe, counter_cache: true
  belongs_to :user
end
