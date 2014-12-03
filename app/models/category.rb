class Category < ActiveRecord::Base
  include FriendlyId

  has_many :categorisations, as: :keywordable, dependent: :destroy
  has_many :keywords,
           -> { order(created_at: :asc) },
           through: :categorisations
  has_many :recipes,
           -> { group('recipes.id, keywords.id').order('count(recipes.id) desc') },
           through: :keywords

  validates :name, uniqueness: true

  friendly_id :name, use: :slugged

  accepts_nested_attributes_for :keywords

  def self.update_all_recipes_count
    transaction do
      where(nil).each(&:update_recipes_count)
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
    update(recipes_count: recipes.approved.as_json.uniq.size)
  end

  def update(attributes)
    Keyword.categorise(self, attributes[:keywords_attributes])
    attributes[:keywords_attributes] = []

    super(attributes)
  end
end
