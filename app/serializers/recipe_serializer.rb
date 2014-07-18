class RecipeSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :description,
             :published_at,
             :slug,
             :url,
             :bookmarks_count,
             :image_urls,
             :approved
end
