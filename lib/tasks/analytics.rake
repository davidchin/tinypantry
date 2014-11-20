namespace :analytics do
  desc 'Import analytics data from GA'

  task :import => :environment do
    Visit.import_all
  end
end
