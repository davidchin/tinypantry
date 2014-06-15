class Category < ActiveRecord::Base
  has_many :categorisations, as: :keywordable, dependent: :destroy
  has_many :keywords, through: :categorisations
  has_many :recipes,
           -> { group('recipes.id').order('count(recipes.id) desc') },
           through: :keywords
end
