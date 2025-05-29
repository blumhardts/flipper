module Flipper
  module UI
    class Configuration
      # Module for handling expression property configuration and type conversion.
      # Provides utilities for working with configured expression properties
      # without complex validation logic.
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



        def self.type_for(properties, property_name)
          return nil unless properties

          # Try string key first, then symbol key
          definition = properties[property_name] || properties[property_name.to_sym]
          return nil unless definition

          definition[:type] || definition['type']
        end

        def self.property_names(properties)
          return [] unless properties

          properties.keys
        end


      end
    end
  end
end
