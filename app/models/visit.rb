require 'google/analytics_client'

class Visit < ActiveRecord::Base
  belongs_to :visitable

  private

  def fetch_outbound_visits(days)
  end
end
