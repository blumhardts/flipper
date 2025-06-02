# UI Complex Expressions Implementation

## Overview
Complex expression support for the Flipper UI gem allows users to create `any` (OR) and `all` (AND) logical groups containing multiple simple expressions. This extends the existing simple property comparisons to support more sophisticated feature flag rules.

## Implementation Architecture

### Frontend Components
- **Expression Type Selection**: Radio buttons in `lib/flipper/ui/views/feature.erb` allow choosing between Property, Any, and All expression types
- **Dynamic Form Management**: JavaScript in `lib/flipper/ui/public/js/application.js` handles:
  - Show/hide logic for simple vs complex forms
  - Add/remove expression rows in complex forms
  - Client-side validation ensuring at least one expression exists
  - Form submission data preparation

### Backend Processing
- **Action Handler**: `lib/flipper/ui/actions/expression_gate.rb` routes simple vs complex expressions:
  - `parse_simple_expression_params` for single property comparisons
  - `parse_complex_expression_params` for any/all groups
  - Trust-based validation approach (minimal server-side checks)
  
### Data Flow
1. User selects expression type (Property/Any/All) via radio buttons
2. JavaScript shows appropriate form section
3. For complex expressions, user can add/remove multiple property comparisons
4. Form submission sends different parameter structures:
   - Simple: `expression_property`, `expression_operator`, `expression_value`
   - Complex: `complex_expression_type` + `complex_expressions[N][property/operator/value]`
5. Backend parses and builds appropriate expression structure for Flipper core

## Expression Data Structures

### Simple Expression
```ruby
{
  "Equal" => [
    { "Property" => ["plan"] },
    "premium"
  ]
}
```

### Complex Any Expression
```ruby
{
  "Any" => [
    { "Equal" => [{ "Property" => ["plan"] }, "premium"] },
    { "Equal" => [{ "Property" => ["premium"] }, true] }
  ]
}
```

### Complex All Expression
```ruby
{
  "All" => [
    { "Equal" => [{ "Property" => ["plan"] }, "premium"] },
    { "GreaterThanOrEqualTo" => [{ "Property" => ["age"] }, 18] }
  ]
}
```

## User Interface Design

### Form Structure
- Top-level radio button selection for expression type
- Simple form: Single row with property/operator/value dropdowns
- Complex form: Multiple expression rows with add/remove functionality
- Consistent Bootstrap styling matching existing UI patterns

### JavaScript Behavior
- No page refreshes during form manipulation
- Minimal client-side validation (required fields, at least one expression)
- Graceful error handling for invalid configurations
- Property options copied from simple form to maintain consistency

## Configuration Integration
Uses existing `Flipper::UI.configuration.expression_properties` system:
```ruby
Flipper::UI.configure do |config|
  config.expression_properties = {
    'plan' => { type: 'string' },
    'age' => { type: 'number' },
    'premium' => { type: 'boolean' }
  }
end
```

## Test Coverage
- **Unit Tests**: 34 passing tests in `spec/flipper/ui/actions/expression_gate_spec.rb`
- **Integration Tests**: Complex expression creation, parameter parsing, error handling
- **Edge Cases**: Empty expressions, invalid types, property type conversion

## Current Limitations
- Creation-only (no inline editing of complex expressions)
- No nesting (any/all cannot contain other any/all groups)
- Simple validation approach (trusts form inputs)
- No visual representation of complex expression logic

## Performance Characteristics
- Minimal JavaScript footprint (< 100 lines additional code)
- Server-side processing remains efficient with trust-based approach
- No additional database queries or complex validation logic
- Client-side DOM manipulation limited to form row management

## Future Enhancement Opportunities
- Nested expression support (any/all containing any/all)
- Visual expression builder with drag-and-drop
- Expression editing capabilities
- Expression templates and saved configurations
- Enhanced validation with detailed error messages
