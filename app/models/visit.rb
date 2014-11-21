require 'google/analytics_client'

class Visit < ActiveRecord::Base
  belongs_to :visitable, polymorphic: true, touch: true

  def self.import_all
    delay.import_total_count
    delay.import_last_30_days_count
  end

  def self.import_total_count(page = 1)
    starts_at = minimum(:updated_at) || 1.year.ago
    data = fetch_recipe_views(starts_at, page)

    data[:formated_rows].each do |row|
      next unless row[:visitable_id]
      visit = find_or_initialize_by(visitable_id: row[:visitable_id])
      visit.total_count = visit.total_count.to_i + row[:count]
      visit.save
    end

    num_page = data[:num_pages] || 0
    import_total_count(page + 1) if num_page > page
  end

  def self.import_last_30_days_count(page = 1)
    starts_at = 30.days.ago
    data = fetch_recipe_views(starts_at, page)

    data[:formated_rows].each do |row|
      next unless row[:visitable_id]
      visit = find_or_initialize_by(visitable_id: row[:visitable_id])
      visit.last_30_days_count = row[:count]
      visit.save
    end

    num_page = data[:num_pages] || 0
    import_last_30_days_count(page + 1) if num_page > page
  end

  def self.fetch_recipe_views(start_date, page = 1)
    data = Google::AnalyticsClient.instance.get(
      'metrics'     => 'ga:pageviews',
      'dimensions'  => 'ga:pagePath',
      'start-date'  => start_date.in_time_zone.strftime('%Y-%m-%d'),
      'max-results' => 10_000,
      'filters'     => 'ga:pagePath=~^/recipes',
      'start-index' => (page - 1) * 10_000 + 1
    ).data

    # Insert additional data
    data.tap do
      data[:num_pages] = ((data['totalResults'] || 0) / (data['itemsPerPage'] || 1)).ceil
      data[:formated_rows] = data['rows'].try(:map) do |row|
        match = row[0].match(/(?:recipes\/)(\d+)/)
        visitable_id = match[1].try(:to_i) if match
        { visitable_id: visitable_id, count: row[1].to_i }
      end || []
    end
  end

  def self.fetch_outbound_recipe_views(start_date, page = 1)
    data = Google::AnalyticsClient.instance.get(
      'metrics'     => 'ga:totalEvents',
      'dimensions'  => 'ga:eventLabel',
      'start-date'  => start_date.in_time_zone.strftime('%Y-%m-%d'),
      'max-results' => 10_000,
      'filters'     => 'ga:eventCategory==Recipe, ga:eventAction==Outbound',
      'start-index' => (page - 1) * 10_000 + 1
    ).data

    # Insert additional data
    data.tap do
      data[:num_pages] = ((data['totalResults'] || 0) / (data['itemsPerPage'] || 1)).ceil
      data[:formated_rows] = data['rows'].try(:map) do |row|
        { visitable_id: row[0].to_i, count: row[1].to_i }
      end || []
    end
  end
end
