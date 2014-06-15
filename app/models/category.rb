class Category < ActiveRecord::Base
  has_many :categorisations, as: :keywordable
  has_many :keywords, through: :categorisations
  has_many :recipes, through: :keywords
end
