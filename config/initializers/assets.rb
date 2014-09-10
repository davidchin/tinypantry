Rails.application.assets.context_class.class_eval do
  include ActionView::Helpers
  include Rails.application.routes.url_helpers
end

Rails.application.config.assets.precompile += %w( vendor.js )
