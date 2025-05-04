require 'flipper/ui/action'
require 'flipper/ui/decorators/feature'

module Flipper
  module UI
    module Actions
      class ExpressionGate < UI::Action
        include FeatureNameFromRoute

        route %r{\A/features/(?<feature_name>.*)/expression/?\Z}

        # {
        #   "#{Flipper::Expression::Comprable.subclass}": [
        #     { Property: ["#{property.name}"] },
        #     value.send(property.type_conversion_method)
        #   ]
        # }
        #
        # {
        #   "Any/All": [
        #     "#{Flipper::Expression::Comprable.subclass}": [
        #       { Property: ["#{property.name}"] },
        #       value.send(property.type_conversion_method)
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
