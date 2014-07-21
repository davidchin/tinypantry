module Api
  class RouteContraint
    attr_reader :version, :default

    def initialize(options)
      @version = options[:version]
      @default = options[:default]
    end

    def matches?(request)
      return true if default

      request.headers[:accept].include?("application/vnd.tinypantry.v#{ version }") ||
      request.params[:version] == version.to_s
    end
  end
end
