# Add Expression Property Configuration

## Change-request
Add configuration system for expression properties to allow Rails applications to define available properties and their types for use in expression-based feature flags. References [plan 001](../plans/001_expression_ui_support_implementation.md).

## Steps

1. **Add expression_properties to UI Configuration class**
   - File: `lib/flipper/ui/configuration.rb`
   - Add `expression_properties` accessor with default empty hash
   - Follow existing configuration pattern used by other UI settings

2. **Add expression_properties accessor to main UI module**
   - File: `lib/flipper/ui.rb` 
   - Add delegation method to access `configuration.expression_properties`
   - Follow pattern used by existing configuration methods

3. **Create configuration module for expression properties**
   - File: `lib/flipper/ui/configuration/expression_properties.rb`
   - Define helper methods for property validation and type checking
   - Support property definitions with types: boolean, string, number
