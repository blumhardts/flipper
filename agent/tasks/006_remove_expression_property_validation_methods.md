# Remove Expression Property Validation Methods

## Change-request
Remove complex validation methods from ExpressionProperties module, keeping only essential type conversion helpers. References [plan 002](../plans/002_simplify_expression_validation_logic.md).

## Steps

1. **Remove validation methods from ExpressionProperties module**
   - File: `lib/flipper/ui/configuration/expression_properties.rb`
   - Remove `valid_property?` method (backward compatibility logic)
   - Remove `valid_operator?` method (HTML ensures valid operators)
   - Remove `valid_operators_for_type` method (not needed without validation)
   - Remove `valid_operator_for_property?` method (complex validation logic)
   - Remove `validate_value_for_type` method (let core library handle)

2. **Keep essential type conversion methods**
   - Keep `type_for` method (needed for form value conversion)
   - Keep `property_names` method (needed for UI dropdown population)
   - Keep `validate_property` and `validate_properties` methods (configuration validation)

3. **Update module documentation**
   - Remove references to validation functionality
   - Update comments to reflect simplified purpose
