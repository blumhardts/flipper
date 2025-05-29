require 'flipper/ui/action'
require 'flipper/ui/decorators/feature'
require 'flipper/ui/util'
require 'flipper/ui/configuration/expression_properties'

module Flipper
  module UI
    module Actions
      class ExpressionGate < UI::Action
        include FeatureNameFromRoute

        route %r{\A/features/(?<feature_name>.*)/expression/?\Z}

        def post
          render_read_only if read_only?

          feature = flipper[feature_name]

          case params['operation']
          when 'enable'
            expression = Flipper::Expression.build(parse_expression_params)
            feature.enable_expression expression
          when 'disable'
            feature.disable_expression
          end

          redirect_to("/features/#{Flipper::UI::Util.escape feature.key}")
        end

        def delete
          render_read_only if read_only?

          feature = flipper[feature_name]
          feature.disable_expression

          redirect_to("/features/#{Flipper::UI::Util.escape feature.key}")
        end

        private



        def parse_expression_params
          property = params['expression_property']
          operator = params['expression_operator']
          value = params['expression_value']

          # Convert value to appropriate type based on property type (if configured)
          properties = UI.configuration.expression_properties
          property_type = UI::Configuration::ExpressionProperties.type_for(properties, property)

          parsed_value = case property_type
          when 'boolean'
            value == 'true'
          when 'number'
            value.include?('.') ? value.to_f : value.to_i
          else # string or unknown property
            value
          end

          # Map operator to expression type
          operator_mapping = {
            'eq' => 'Equal',
            'ne' => 'NotEqual',
            'gt' => 'GreaterThan',
            'gte' => 'GreaterThanOrEqualTo',
            'lt' => 'LessThan',
            'lte' => 'LessThanOrEqualTo'
          }

          expression_type = operator_mapping[operator]

          # Build expression hash in the format: {"Equal": [{"Property": ["plan"]}, "basic"]}
          {
            expression_type => [
              { "Property" => [property] },
              parsed_value
            ]
          }
        end
      end
    end
  end
end
