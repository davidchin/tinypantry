module Cacheable
  extend ActiveSupport::Concern

  included do
    def self.cache_key
      timestamp = last_updated_at.try(:utc).try(:to_s, :nsec)
      "#{ model_name.cache_key }/all-#{ count }-#{ timestamp }"
    end

    def self.last_updated_at
      maximum(:updated_at)
    end
  end
end
