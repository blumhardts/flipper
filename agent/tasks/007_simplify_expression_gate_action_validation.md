# Simplify Expression Gate Action Validation

## Change-request
Remove complex validation logic from ExpressionGate action, trusting form inputs and letting core Flipper handle validation. References [plan 002](../plans/002_simplify_expression_validation_logic.md).

## Steps

1. **Remove validation from ExpressionGate action**
   - File: `lib/flipper/ui/actions/expression_gate.rb`
   - Remove `validate_expression_params` method entirely
   - Remove validation call from `post` method
   - Remove error handling for validation failures

2. **Simplify parameter parsing**
   - Keep `parse_expression_params` method for type conversion
   - Remove validation checks within parsing
   - Keep type conversion logic (required by core library)
   - Simplify method to focus only on conversion, not validation

3. **Update error handling**
   - Let `Flipper::Expression.build` exceptions bubble up naturally
   - Remove custom error messages and redirects for validation
   - Keep only basic CSRF and method handling
