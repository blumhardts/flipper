# Implement Expression Form Validation

## Change-request  
Add backend validation for expression forms with proper error handling and user feedback following existing error patterns. References [plan 001](../plans/001_expression_ui_support_implementation.md).

## Steps

1. **Add expression validation to ExpressionGate action**
   - File: `lib/flipper/ui/actions/expression_gate.rb`
   - Validate property exists in configured properties
   - Validate operator is supported (eq, gt, lt, gte, lte, ne)
   - Validate value matches property type

2. **Add error handling and redirect with error message**
   - Follow existing error handling pattern from other gate actions
   - Redirect back to feature page with error parameter
   - Display validation errors in feature view

3. **Add property and operator validation helpers**
   - File: `lib/flipper/ui/configuration/expression_properties.rb`
   - Methods to validate property names and types
   - Methods to validate operators for given property types
