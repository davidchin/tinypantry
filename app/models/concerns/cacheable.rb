module Cacheable
  extend ActiveSupport::Concern

  included do
    def self.cache_key
      scoped = where(nil)

      keys = ['all']
      keys << scoped.current_page if scoped.respond_to?(:current_page)
      keys << count(:all)
      keys << last_updated_at.utc.try(:to_s, :nsec) if last_updated_at.respond_to?(:utc)

      "#{ model_name.cache_key }/#{ keys.join('-') }"
    end

    def self.last_updated_at
      @last_updated_at ||= pluck(:updated_at).max
    end
  end
end
