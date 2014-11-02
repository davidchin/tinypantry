module Cacheable
  extend ActiveSupport::Concern

  included do
    def self.cache_key
      scoped = where(nil)

      keys = ['all']
      keys << scoped.current_page if scoped.respond_to?(:current_page)
      keys << scoped.count(:all)
      keys << scoped.first.id
      keys << scoped.last.id
      keys << last_updated_at.utc.try(:to_s, :nsec) if last_updated_at.respond_to?(:utc)

      "#{ model_name.cache_key }/#{ keys.join('-') }"
    end

    def self.digest_cache_key
      records = where(nil).load
      Digest::MD5.hexdigest(Marshal.dump(records))

    rescue
      Digest::MD5.hexdigest(Marshal.dump(records.to_json))
    end

    def self.last_updated_at
      @last_updated_at ||= where(nil).pluck(:updated_at).max
    end
  end
end
