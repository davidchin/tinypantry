class Category < ActiveRecord::Base
  include FriendlyId

  has_many :categorisations, as: :keywordable, dependent: :destroy
  has_many :keywords, through: :categorisations
  has_many :recipes,
           -> { group('recipes.id').order('count(recipes.id) desc') },
           through: :keywords

  validates :name, uniqueness: true

  friendly_id :name, use: :slugged

  accepts_nested_attributes_for :keywords, allow_destroy: true
end
