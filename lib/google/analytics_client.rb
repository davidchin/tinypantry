require 'google/api_client'

module Google
  class AnalyticsClient
    delegate :execute, to: :client

    def initialize
      client.authorization = account.authorize
    end

    def api
      @api ||= client.discovered_api('analytics', 'v3')
    end

    def get(params = {})
      params = params.reverse_merge(
        'ids'        => Rails.application.secrets.ga_profile_id,
        'metrics'    => 'ga:pageviews',
        'start-date' => 7.days.ago.in_time_zone.strftime('%Y-%m-%d'),
        'end-date'   => Time.now.in_time_zone.strftime('%Y-%m-%d')
      )

      execute(api_method: api.data.ga.get, parameters: params)
    end

    private

    def client
      @client ||= Google::APIClient.new(application_name: 'tinypantry.com')
    end

    def key
      @key ||= OpenSSL::PKey::RSA.new(Rails.application.secrets.ga_private_key, 'notasecret')
    end

    def account
      @account ||= Google::APIClient::JWTAsserter.new(
        '383848500300-lm0c75i5jsth8lv1o36nou3fe3899l3s@developer.gserviceaccount.com',
        ['https://www.googleapis.com/auth/analytics.readonly',
         'https://www.googleapis.com/auth/prediction'],
        key
      )
    end
  end
end
