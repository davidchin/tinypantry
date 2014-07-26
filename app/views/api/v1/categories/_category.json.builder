json.extract! category, :id, :name

json.keywords do
  json.array! category.keywords, :id, :name
end
