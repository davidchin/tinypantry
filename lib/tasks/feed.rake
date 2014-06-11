namespace :feed do
  desc 'Import all feeds and create new recipes from them'

  task :import => :environment do
    Feed.import_all
  end
end
