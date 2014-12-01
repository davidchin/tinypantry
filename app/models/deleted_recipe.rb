class DeletedRecipe < ActiveRecord::Base
  belongs_to :feed

  validates :url, presence: true
end
