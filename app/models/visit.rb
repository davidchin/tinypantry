require 'google/analytics_client'

class Visit < ActiveRecord::Base
  belongs_to :visitable, polymorphic: true, touch: true

  def self.import_all
    delay.import_total_count
    delay.import_last_30_days_count
  end

  def self.import_total_count(page = 1)
    data = fetch_data(maximum(:updated_at), page)

    data[:formated_rows].each do |row|
      visit = find_or_initialize_by(visitable_id: row[:visitable_id])
      visit.total_count = visit.total_count.to_i + row[:count]
      visit.save
    end

    import_total_count(page + 1) if data['num-pages'] > page
  end

  def self.import_last_30_days_count(page = 1)
    data = fetch_data(30.days.ago, page)

    data[:formated_rows].each do |row|
      visit = find_or_initialize_by(visitable_id: row[:visitable_id])
      visit.last_30_days_count = row[:count]
      visit.save
    end

    import_last_30_days_count(page + 1) if data['num-pages'] > page
  end

  def self.fetch_data(start_date, page = 1)
    data = Google::AnalyticsClient.instance.get(
      'metrics'     => 'ga:totalEvents',
      'dimensions'  => 'ga:eventLabel',
      'start-date'  => start_date.in_time_zone.strftime('%Y-%m-%d'),
      'max-results' => 10_000,
      'filters'     => 'ga.eventCategory==Recipe, ga.eventAction==Outbound',
      'start-index' => (page - 1) * 10_000 + 1
    ).data

    # Insert additional data
    data.tap do
      data[:num_pages] = (data['totalResults'] / data['itemsPerPage']).ceil
      data[:formated_rows] = data['rows'].try(:map) do |row|
        { visitable_id: row[0].to_i, count: row[1] }
      end || []
    end
  end
end