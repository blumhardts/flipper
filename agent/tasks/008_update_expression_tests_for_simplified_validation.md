# Update Expression Tests for Simplified Validation

## Change-request
Update test suite to reflect simplified validation approach, removing tests for removed validation methods and focusing on core functionality. References [plan 002](../plans/002_simplify_expression_validation_logic.md).

## Steps

1. **Remove validation method tests**
   - File: `spec/flipper/ui/configuration/expression_properties_spec.rb`
   - Remove tests for `valid_property?` method
   - Remove tests for `valid_operator?` method  
   - Remove tests for `valid_operators_for_type` method
   - Remove tests for `valid_operator_for_property?` method
   - Remove tests for `validate_value_for_type` method
   - Remove backward compatibility test scenarios

2. **Update ExpressionGate action tests**
   - File: `spec/flipper/ui/actions/expression_gate_spec.rb`
   - Remove validation error test scenarios
   - Remove tests for invalid property/operator combinations
   - Focus tests on successful expression creation and deletion
   - Add tests to verify exceptions bubble up for invalid expressions

3. **Add operator HTML validation tests**
   - Test that each operator in HTML dropdown works correctly
   - Verify form submission with each operator type
   - Ensure HTML contains only valid operator values
