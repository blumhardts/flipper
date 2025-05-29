# UI Expression Implementation

## Overview
Simplified implementation of expression gate support in the Flipper UI, allowing users to create property-based feature flag rules through web forms alongside existing actors, groups, and percentage gates. Designed for self-hosted internal usage with trust-based validation.

## Configuration System

### Core Configuration
- [`lib/flipper/ui/configuration.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/configuration.rb) - Added `expression_properties` accessor with default empty hash
- [`lib/flipper/ui.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui.rb) - Added delegation method for accessing configured properties

### Expression Properties Configuration
- **Removed** - Configuration logic has been inlined into the action handler for simplicity
- Property type lookup is now handled directly in [`lib/flipper/ui/actions/expression_gate.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/expression_gate.rb)

### Usage Pattern
```ruby
Flipper::UI.configure do |config|
  config.expression_properties = {
    user_id: { type: 'string' },
    age: { type: 'number' },
    premium: { type: 'boolean' }
  }
end
```

## Action Handler

### Expression Gate Action
- [`lib/flipper/ui/actions/expression_gate.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/expression_gate.rb) - Simplified action handler with:
  - POST request handling for enabling expressions
  - DELETE request handling for disabling expressions
  - Parameter sanitization with `.to_s.strip` following UI conventions
  - Constant operator mapping to expression class names for maintainability
  - Inlined property type lookup with `property_type_for` method
  - Type conversion based on configured property types
  - Expression hash building using `Flipper::Expression.build`
  - Exception bubbling for invalid expressions
  - CSRF protection

### Route Registration
- [`lib/flipper/ui/middleware.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/middleware.rb#L26) - Route `/features/{name}/expression` registered for ExpressionGate action

## UI Integration

### Feature View Updates
- [`lib/flipper/ui/views/feature.erb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/views/feature.erb) - Added expression gate section with:
  - Expression display showing current state in human-readable format
  - Form with dropdowns for property, operator, and value selection
  - Toggle functionality matching existing gate patterns (show/hide forms)
  - Remove functionality for existing expressions
  - Bootstrap styling throughout
  - Proper CSRF protection and form actions
  - Permission checks using `write_allowed?`

### Feature Decorator Support
- [`lib/flipper/ui/decorators/feature.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/decorators/feature.rb) - Added expression methods:
  - `has_expression?` - checks if expression gate is enabled
  - `expression_summary` - short format (e.g., "plan = 'basic'")
  - `expression_description` - verbose format (e.g., "plan equals 'basic'")  
  - `expression_state` - gate state for sorting/display
  - Updated `gates_in_words` to include expression information
  - Helper methods for operator and value formatting

## Error Handling

### Trust-Based Approach
Simplified error handling in [`lib/flipper/ui/actions/expression_gate.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/expression_gate.rb):
- No frontend form validation (trusts HTML dropdowns)
- Basic parameter sanitization with `.to_s.strip` but no validation
- Core Flipper library handles expression validation
- Invalid expressions cause runtime exceptions (acceptable for internal usage)

### Exception Management
- `Flipper::Expression.build` exceptions bubble up naturally
- Server errors for malformed expressions (acceptable security risk)
- No custom error messages or redirects for validation failures

## Test Coverage

### Focused Test Suite
- [`spec/flipper/ui/actions/expression_gate_spec.rb`](file:///Users/samblumhardt/Developer/flipper/spec/flipper/ui/actions/expression_gate_spec.rb) - Action functionality and operator validation tests
- [`spec/flipper/ui/decorators/feature_spec.rb`](file:///Users/samblumhardt/Developer/flipper/spec/flipper/ui/decorators/feature_spec.rb) - Decorator method tests
- **Removed** - Configuration tests are no longer needed since module was removed
- Tests focus on core functionality and HTML operator validation rather than complex error scenarios

## Key Features

### Property-Based Expressions
- Support for boolean, string, and number property types
- All comparison operators: eq, ne, gt, gte, lt, lte
- Type-aware value conversion based on configuration

### User Experience
- Human-readable expression display (e.g., "age ≥ 21", "plan equals 'basic'")
- Consistent UI patterns matching existing gate types
- Toggle forms for adding/editing expressions
- Runtime errors for invalid expressions (acceptable for internal usage)

### Technical Implementation
- Bootstrap-only styling, no custom CSS
- Reuses existing Flipper Expression classes and evaluation logic
- Follows established UI patterns and conventions
- Trust-based approach suitable for self-hosted internal tools

## Simplification Benefits
- **Reduced Complexity**: ~170 lines of validation code removed, entire module eliminated
- **Cleaner Codebase**: Focus on core functionality, not edge cases
- **Better Performance**: Less validation overhead, no separate module loading
- **Easier Maintenance**: Fewer code paths, test scenarios, and files to maintain
- **Better Locality**: Type logic co-located with usage in action handler
- **Clear Trade-offs**: Empty dropdowns and runtime errors are acceptable risks

## Current Limitations
- Phase 1: Simple property comparisons only (no nested expressions)
- Phase 1: Creation only (no inline editing of existing expressions)
- Empty `expression_properties` results in empty dropdowns
- Invalid expressions cause server exceptions rather than friendly errors
- Future enhancements documented for nested logical expressions (all/any) and editing capabilities
