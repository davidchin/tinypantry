namespace :exceptions do
  desc 'List the class names of all possible exceptions'

  task :list => :environment do
    exceptions = []

    ObjectSpace.each_object(Class) do |k|
      exceptions << k if k.ancestors.include?(Exception)
    end

    puts exceptions.sort { |a, b| a.to_s <=> b.to_s }.join("\n")
  end
end
