module RateLimiter
  module Policy
    class RouteBasedPolicy
      def initialize(routes:)
        @routes = routes
      end

      def applicable?(env)
        @routes.include?(env['REQUEST_PATH'])
      end
    end
  end
end
