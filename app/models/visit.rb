class Visit < ActiveRecord::Base
  belongs_to :visitable, polymorphic: true, counter_cache: true, touch: true
  belongs_to :user

  scope :unique_count, -> { select(:ip_address).distinct.count }
end
