module Snapshot
  class Renderer
    BOTS = [
      'baiduspider',
      'facebookexternalhit',
      'twitterbot',
      'rogerbot',
      'linkedinbot',
      'embedly',
      'bufferbot',
      'quora link preview',
      'showyoubot',
      'outbrain',
      'pinterest',
      'developers.google.com/+/web/snippet',
      'slackbot'
    ]

    def initialize(app)
      @app = app
    end

    def call(env)
      fragment = parse_fragment(env)

      if fragment
        render_fragment(env, fragment)
      elsif bot_request?(env) && page_request?(env)
        fragment = { path: env['REQUEST_PATH'], query: env['QUERY_STRING'] }
        render_fragment(env, fragment)
      else
        @app.call(env)
      end
    end

    private

    def parse_fragment(env)
      regexp = /(?:_escaped_fragment_=)([^&]*)/
      query = env['QUERY_STRING']
      match = regexp.match(query)

      { path: URI.unescape(match[1]), query: query.sub(regexp, '') } if match
    end

    def render_fragment(env, fragment)
      url = "#{ env['rack.url_scheme'] }://#{ env['HTTP_HOST'] }#{ fragment[:path] }"
      url += "?#{ fragment[:query] }" if fragment[:query].present?

      body = `node_modules/.bin/phantomjs lib/snapshot/browser.js #{ url } --load-images=false`

      status, headers = @app.call(env)
      response = Rack::Response.new(body, status, headers)
      response.finish
    end

    def bot_request?(env)
      user_agent = env['HTTP_USER_AGENT']
      buffer_agent = env['X-BUFFERBOT']

      buffer_agent || (user_agent && BOTS.any? { |bot| bot.include?(user_agent.downcase) })
    end

    def page_request?(env)
      method = env['REQUEST_METHOD'] || 'GET'
      accept = env['HTTP_ACCEPT']
      path = env['REQUEST_PATH']

      method.upcase == 'GET' &&
      accept =~ /text\/html/ &&
      !(path =~ /^\/(?:assets|api)/) &&
      !(path =~ /\.[a-z0-9]{2,4}$/i)
    end
  end
end
