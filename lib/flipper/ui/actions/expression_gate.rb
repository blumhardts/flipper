require 'flipper/ui/action'
require 'flipper/ui/decorators/feature'

module Flipper
  module UI
    module Actions
      class ExpressionGate < UI::Action
        include FeatureNameFromRoute

        route %r{\A/features/(?<feature_name>.*)/expression/?\Z}

        # expression: ["min_client_version", "LessThan", 123]
        # expression: { Any: ["min_client_version", "LessThan", 123], [is_registered, "Equal", true] }
        #
        #{
        #   "LessThan": [
        #     { Property: ["min_client_version"] },
        #     "foobarbaz", 123, true, false
        #   ]
        # }
        #
        # {
        #   "Any/All": [
        #     "LessThan": [
        #       { Property: ["min_client_version"] },
        #       "foobarbaz", 123, true, false
        #     ]
        #   ]
        # }
        #
        def post
          render_read_only if read_only?

          feature = flipper[feature_name]

          expression = Flipper::Expression.build(params['expression'])
          feature.enable_expression expression

          redirect_to("/features/#{Flipper::UI::Util.escape feature.key}")
        end

        def delete
          render_read_only if read_only?

          feature = flipper[feature_name]
          feature.disable_expression

          redirect_to("/features/#{Flipper::UI::Util.escape feature.key}")
        end
      end
    end
  end
end
