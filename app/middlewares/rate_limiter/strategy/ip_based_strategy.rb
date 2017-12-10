module RateLimiter
  module Strategy
    class IpBasedStrategy
      def next_result(env)
      end

      class Result
        def format_response(app, env)
        end

        def allowed?(env)
        end

        def modified(app, env)
        end

        def forbid(app, env)
        end
      end
    end
  end
end
