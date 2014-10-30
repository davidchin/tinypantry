module Snapshot
  class Renderer
    def initialize(app)
      @app = app
    end

    def call(env)
      if fragment = parse_fragment(env)
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

      { path: match[1], query: query.sub(regexp, '') } if match
    end

    def render_fragment(env, fragment)
      url = "#{ env['rack.url_scheme'] }://#{ env['HTTP_HOST'] }#{ fragment[:path] }"
      url = url + "?#{ fragment[:query] }" if fragment[:query].present?

      output = `node_modules/.bin/phantomjs lib/snapshot/browser.js #{ url } --load-images=false`

      Rack::Response.new(output, 200, [])
    end
  end
end
