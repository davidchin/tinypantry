class Categorisation < ActiveRecord::Base
  belongs_to :keywordable, polymorphic: true, touch: true
  belongs_to :keyword

  after_commit :update_counter

  def update_counter
    if keywordable_type == 'Category'
      keywordable.update_recipes_count
    elsif keywordable_type == 'Recipe'
      keywordable.categories.update_all_recipes_count
    end
  end
end
