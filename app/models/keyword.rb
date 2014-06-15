class Keyword < ActiveRecord::Base
  has_many :categorisations
  has_many :recipes,
           through: :categorisations,
           source: :keywordable,
           source_type: 'Recipe'
  has_many :categories,
           through: :categorisations,
           source: :keywordable,
           source_type: 'Category'
end
