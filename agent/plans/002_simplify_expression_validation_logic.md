# Simplify Expression Validation Logic

## Goal
Remove complex property validation and backward compatibility support from the expression UI implementation. Simplify the codebase by trusting that self-hosted internal users will only use configured properties and rely on core Flipper validation where possible.

## Scope
- **Remove**: Complex property validation, operator validation, backward compatibility logic
- **Keep**: Basic type conversion (UI action still needs to convert strings to proper types)
- **Simplify**: Error handling by letting exceptions bubble up initially

## Key Changes

### Configuration Simplification
- Remove validation methods from `ExpressionProperties` module
- Keep only type conversion helper methods
- Remove backward compatibility checks for nil properties
- If `expression_properties` is empty/nil, leave UI select elements empty

### Action Handler Simplification  
- Remove property existence validation
- Remove operator validation (trust HTML dropdown values)
- Keep type conversion (core library requires it)
- Remove complex error handling, let `Flipper::Expression.build` exceptions bubble up
- Simplify parameter parsing logic

### UI Behavior Changes
- Empty `expression_properties` results in empty dropdowns (acceptable UX)
- Invalid operator/property combinations will cause runtime exceptions (acceptable risk)
- Form submissions with manipulated values will bomb out (acceptable security risk)

## Investigation Findings
- **Type Conversion**: Core `Flipper::Expression.build` does NOT auto-convert string values
- **Form Values**: All HTML form values come as strings, we must convert before calling `Expression.build`
- **Operators**: HTML dropdown ensures valid operators, no server validation needed

## Benefits
- **Reduced Complexity**: Remove ~50 lines of validation logic
- **Simpler Configuration**: No backward compatibility concerns
- **Cleaner Action**: Focus on core functionality, not edge case validation
- **Faster Implementation**: Less code paths to test and maintain

## Acceptable Trade-offs
- **Empty UI**: Users with no configured properties see empty dropdowns
- **Runtime Errors**: Invalid expressions cause exceptions instead of friendly errors
- **Security Risk**: Malicious form manipulation can cause server errors
- **User Experience**: Less helpful validation messages initially

## Success Criteria
- Expression UI works with properly configured `expression_properties`
- Invalid expressions cause clear runtime exceptions
- Reduced lines of code and complexity
- All existing functionality preserved for valid configurations
