class Categorisation < ActiveRecord::Base
  belongs_to :keywordable, polymorphic: true, touch: true
  belongs_to :keyword

  default_scope { where(hidden_at: nil) }
  scope :with_hidden, -> { unscope(where: :hidden_at) }

  after_commit :update_counter
  after_destroy :remove_orphan_keyword

  def update_counter
    if keywordable_type == 'Category'
      keywordable.update_recipes_count
    elsif keywordable_type == 'Recipe'
      keywordable.categories.update_all_recipes_count
    end
  end

  def remove_orphan_keyword
    keyword.destroy if keyword.categorisations.empty?
  end

  def hidden?
    hidden_at != nil
  end

  def hide
    return self if hidden?

    update(hidden_at: Time.now.in_time_zone)
  end

  def unhide
    return self unless hidden?

    update(hidden_at: nil)
  end
end
