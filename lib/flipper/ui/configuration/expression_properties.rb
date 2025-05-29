module Flipper
  module UI
    class Configuration
      module ExpressionProperties
        SUPPORTED_TYPES = %w(boolean string number).freeze

        def self.validate_property(name, definition)
          unless definition.is_a?(Hash)
            raise ArgumentError, "Property definition for '#{name}' must be a hash"
          end

          type = definition[:type] || definition['type']
          unless type
            raise ArgumentError, "Property '#{name}' must specify a type"
          end

          unless SUPPORTED_TYPES.include?(type.to_s)
            raise ArgumentError, "Property '#{name}' has unsupported type '#{type}'. Supported types: #{SUPPORTED_TYPES.join(', ')}"
          end
        end

        def self.validate_properties(properties)
          return if properties.nil? || properties.empty?

          unless properties.is_a?(Hash)
            raise ArgumentError, "Expression properties must be a hash"
          end

          properties.each do |name, definition|
            validate_property(name, definition)
          end
        end

        def self.type_for(properties, property_name)
          return nil unless properties&.key?(property_name)

          definition = properties[property_name]
          definition[:type] || definition['type']
        end

        def self.property_names(properties)
          return [] unless properties

          properties.keys
        end

        def self.valid_property?(properties, property_name)
          return false unless properties&.key?(property_name)
          true
        end

        def self.valid_operator?(operator)
          %w(eq ne gt gte lt lte).include?(operator.to_s)
        end

        def self.valid_operators_for_type(type)
          case type.to_s
          when 'boolean'
            %w(eq ne)
          when 'string'
            %w(eq ne)
          when 'number'
            %w(eq ne gt gte lt lte)
          else
            []
          end
        end

        def self.valid_operator_for_property?(properties, property_name, operator)
          return false unless valid_property?(properties, property_name)
          return false unless valid_operator?(operator)

          type = type_for(properties, property_name)
          valid_operators_for_type(type).include?(operator.to_s)
        end

        def self.validate_value_for_type(value, type)
          case type.to_s
          when 'boolean'
            %w(true false).include?(value.to_s)
          when 'string'
            true
          when 'number'
            value.to_s.match?(/\A-?\d+(\.\d+)?\z/)
          else
            false
          end
        end
      end
    end
  end
end
