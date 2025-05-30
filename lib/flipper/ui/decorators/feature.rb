require 'delegate'
require 'flipper/ui/decorators/gate'
require 'flipper/ui/util'

module Flipper
  module UI
    module Decorators
      class Feature < SimpleDelegator
        include Comparable

        # Public: The feature being decorated.
        alias_method :feature, :__getobj__

        # Internal: Used to preload description if descriptions_source is
        # configured for Flipper::UI.
        attr_accessor :description

        # Internal: Used to preload actor names if actor_names_source is
        # configured for Flipper::UI.
        attr_accessor :actor_names

        # Public: Returns name titleized.
        def pretty_name
          @pretty_name ||= Util.titleize(name)
        end

        def color_class
          case feature.state
          when :on
            'bg-success'
          when :off
            'bg-danger'
          when :conditional
            'bg-warning'
          end
        end

        def gates_in_words
          return "Fully Enabled" if feature.boolean_value

          statuses = []

          if feature.actors_value.count > 0
            statuses << %Q(<span data-toggle="tooltip" data-placement="bottom" title="#{Util.to_sentence(feature.actors_value.to_a)}">) + Util.pluralize(feature.actors_value.count, 'actor', 'actors') + "</span>"
          end

          if feature.groups_value.count > 0
            statuses << %Q(<span data-toggle="tooltip" data-placement="bottom" title="#{Util.to_sentence(feature.groups_value.to_a)}">) + Util.pluralize(feature.groups_value.count, 'group', 'groups') + "</span>"
          end

          if feature.percentage_of_actors_value > 0
            statuses << "#{feature.percentage_of_actors_value}% of actors"
          end

          if feature.percentage_of_time_value > 0
            statuses << "#{feature.percentage_of_time_value}% of time"
          end

          if has_expression?
            statuses << "actors with #{expression_summary}"
          end

          Util.to_sentence(statuses)
        end

        def gate_state_title
          case feature.state
          when :on
            "Fully enabled"
          when :conditional
            "Conditionally enabled"
          else
            "Disabled"
          end
        end

        def pretty_enabled_gate_names
          enabled_gates.map { |gate| Util.titleize(gate.key) }.sort.join(', ')
        end

        StateSortMap = {
          on: 1,
          conditional: 2,
          off: 3,
        }.freeze

        def <=>(other)
          if state == other.state
            key <=> other.key
          else
            StateSortMap[state] <=> StateSortMap[other.state]
          end
        end

        # Public: Check if feature has an expression gate enabled.
        def has_expression?
          feature.expression_value && !feature.expression_value.empty? ? true : false
        end

        # Public: Returns the state for just the expression gate.
        def expression_state
          has_expression? ? :conditional : :off
        end

        # Public: Get human-readable summary of the expression.
        def expression_summary
          result = nil
          parse_simple_expression do |property_name, operator, value_part|
            operator_text = format_operator(operator)
            result = "#{property_name} #{operator_text} #{format_value(value_part)}"
          end

          return result if result
          return "none" unless has_expression?
          "complex expression"
        end

        # Public: Get detailed human-readable description of the expression.
        def expression_description
          result = nil
          parse_simple_expression do |property_name, operator, value_part|
            operator_text = format_operator_verbose(operator)
            result = "#{property_name} #{operator_text} #{format_value(value_part)}"
          end

          return result if result
          return "No expression set" unless has_expression?
          expr_value = feature.expression_value
          return "Invalid expression format" unless expr_value.is_a?(Hash)
          "Complex expression - #{expr_value.inspect}"
        end

        # Public: Extract form values from current expression for editing.
        # Returns hash with property, operator, and value, or empty hash for complex expressions.
        def expression_form_values
          parse_simple_expression do |property_name, operator, value_part|
            form_operator = map_expression_operator_to_form(operator)
            return {
              property: property_name,
              operator: form_operator,
              value: value_part.to_s
            }
          end

          {}
        end

        private

        # Parse simple expression and yield property name, operator, and value if found.
        # Returns early from block if simple expression is found, otherwise continues execution.
        def parse_simple_expression
          return unless has_expression?

          expr_value = feature.expression_value
          return unless expr_value.is_a?(Hash)

          # Handle simple comparison expressions like {"Equal": [{"Property": ["plan"]}, "basic"]}
          expr_value.each do |operator, args|
            next unless args.is_a?(Array) && args.length == 2

            property_part = args[0]
            value_part = args[1]

            if property_part.is_a?(Hash) && property_part.has_key?("Property")
              property_name = property_part["Property"]&.first
              if property_name && !value_part.nil?
                yield property_name, operator, value_part
              end
            end
          end
        end

        def format_operator(operator)
          case operator
          when "Equal" then "="
          when "NotEqual" then "≠"
          when "GreaterThan" then ">"
          when "GreaterThanOrEqualTo" then "≥"
          when "LessThan" then "<"
          when "LessThanOrEqualTo" then "≤"
          else operator.downcase
          end
        end

        def format_operator_verbose(operator)
          case operator
          when "Equal" then "equals"
          when "NotEqual" then "does not equal"
          when "GreaterThan" then "is greater than"
          when "GreaterThanOrEqualTo" then "is greater than or equal to"
          when "LessThan" then "is less than"
          when "LessThanOrEqualTo" then "is less than or equal to"
          else operator.downcase
          end
        end

        def format_value(value)
          case value
          when String then "\"#{value}\""
          when true, false then value.to_s
          else value.to_s
          end
        end

        def map_expression_operator_to_form(operator)
          case operator
          when "Equal" then "eq"
          when "NotEqual" then "ne"
          when "GreaterThan" then "gt"
          when "GreaterThanOrEqualTo" then "gte"
          when "LessThan" then "lt"
          when "LessThanOrEqualTo" then "lte"
          else "eq" # Default fallback
          end
        end
      end
    end
  end
end
