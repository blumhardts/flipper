require 'flipper/ui/action'
require 'flipper/ui/decorators/feature'

module Flipper
  module UI
    module Actions
      class PercentageOfActorsGate < UI::Action
        include FeatureNameFromRoute

        route %r{\A/features/(?<feature_name>.*)/percentage_of_actors/?\Z}

        def post
          render_read_only if read_only?

          feature = flipper[feature_name]
          @feature = Decorators::Feature.new(feature)

          begin
            feature.enable_percentage_of_actors params['value']
          rescue ArgumentError => exception
            error = "Invalid percentage of actors value: #{exception.message}"
            redirect_to("/features/#{Flipper::UI::Util.escape @feature.key}?error=#{Flipper::UI::Util.escape error}")
          end

          redirect_to "/features/#{Flipper::UI::Util.escape @feature.key}"
        end
      end
    end
  end
end
