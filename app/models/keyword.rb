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

  validates :name, uniqueness: true, presence: true

  def self.categorise(keywordable, keywords_attributes, options = {})
    return if keywords_attributes.blank?

    keywords_attributes.each do |attributes|
      keyword = Keyword.find_by('id = ? OR name = ?', attributes[:id], attributes[:name])

      if keyword
        categorisation = keyword.categorisations.with_hidden.find_by(keywordable: keywordable)

        if attributes[:name].blank? || attributes[:_destroy]
          categorisation.try(options[:soft_delete] ? :hide : :destroy)
        else
          categorisation.unhide if categorisation.try(:hidden?)
          keyword.update(attributes)
        end
      elsif attributes[:name].present?
        keyword = Keyword.create(attributes)
        keyword.categorisations.create(keywordable: keywordable)
      end
    end
  end

  def hidden?(keywordable)
    categorisation = categorisations.with_hidden.find_by(keywordable: keywordable)
    categorisation.hidden? if categorisation
  end
end
