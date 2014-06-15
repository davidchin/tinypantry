class Categorisation < ActiveRecord::Base
  belongs_to :keywordable, polymorphic: true
  belongs_to :keyword
end
