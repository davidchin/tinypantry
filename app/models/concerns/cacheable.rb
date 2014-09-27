module Cacheable
  extend ActiveSupport::Concern

  included do
    def self.cache_key
      timestamp = last_updated_at.try(:utc).try(:to_s, :nsec)
      "#{ model_name.cache_key }/all-#{ count(:all) }-#{ timestamp }"
    end

    def self.last_updated_at
      select(:updated_at).map(&:updated_at).max
    end
  end
end
