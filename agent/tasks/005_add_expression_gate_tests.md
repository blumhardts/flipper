# Add Expression Gate Tests

## Change-request
Add comprehensive test coverage for expression gate functionality including action handlers, validation, and UI integration. References [plan 001](../plans/001_expression_ui_support_implementation.md).

## Steps

1. **Add ExpressionGate action tests**
   - File: `spec/flipper/ui/actions/expression_gate_spec.rb`
   - Test POST request with valid expression data
   - Test DELETE request to disable expression
   - Test validation error scenarios

2. **Add configuration tests for expression properties**
   - File: `spec/flipper/ui/configuration/expression_properties_spec.rb`
   - Test property validation methods
   - Test type checking functionality
   - Test integration with main configuration

3. **Add feature decorator tests for expression methods**
   - File: `spec/flipper/ui/decorators/feature_spec.rb`
   - Test expression display formatting
   - Test expression state detection
   - Add to existing decorator test suite
