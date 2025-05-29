# Clean Up Unused Validation Code

## Change-request
Remove any remaining unused imports, comments, or code related to the removed validation system. References [plan 002](../plans/002_simplify_expression_validation_logic.md).

## Steps

1. **Clean up action imports**
   - File: `lib/flipper/ui/actions/expression_gate.rb`
   - Remove require for expression_properties if no longer needed
   - Clean up any unused method references

2. **Update configuration documentation**
   - File: `lib/flipper/ui/configuration.rb`
   - Update comment for `expression_properties` to reflect simplified usage
   - Remove references to validation capabilities

3. **Remove unused test helper methods**
   - Review test files for any helper methods only used for validation testing
   - Clean up test setup that was specific to validation scenarios

4. **Verify no broken references**
   - Check for any remaining calls to removed validation methods
   - Ensure all imports and requires are still valid
   - Run tests to verify no missing method errors
