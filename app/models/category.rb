class Category < ActiveRecord::Base
  include FriendlyId

  has_many :categorisations, as: :keywordable, dependent: :destroy
  has_many :keywords,
           -> { order(created_at: :asc) },
           through: :categorisations
  has_many :recipes,
           -> { group('recipes.id').order('count(recipes.id) desc') },
           through: :keywords

  validates :name, uniqueness: true

  friendly_id :name, use: :slugged

  accepts_nested_attributes_for :keywords, allow_destroy: true

  def self.update_all_recipes_count
    transaction do
      where(nil).each do |category|
        category.update_recipes_count
      end
    end
  end

  def self.order_by(key = 'name')
    case key
    when 'id'
      order(id: :asc)
    else
      order(name: :asc)
    end
  end

  def update_recipes_count
    update_columns(recipes_count: recipes.uniq.size)
  end
end
