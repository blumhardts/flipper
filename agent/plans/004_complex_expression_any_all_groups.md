# Plan 004: Complex Expression Any/All Groups

## Overview
Add support for creating complex expressions using `any` and `all` logical groups in the Flipper UI. This integrates with the existing simple expression form by adding a top-level choice between simple and complex expressions.

## User Experience Flow
1. User sees expression form with choices: "Property", "Any", and "All
2. If Property: Show existing simple property/operator/value form
3. If "Any" or "All": Show complex expression builder where user can:
   - Add multiple simple expressions to the group
   - Remove expressions from the group
   - Submit the complex expression

## Technical Implementation

### UI Structure
- Add button group for expression type selection
- Show/hide appropriate form sections based on selection
- Complex form contains:
  - List of simple expressions
  - "Add Expression" button
  - "Remove" buttons for each expression
  - Single "Save" button

### JavaScript Requirements (Minimal)
- Show/hide form sections based on type selection
- Add new expression row when "Add Expression" clicked
- Remove expression row when "Remove" clicked
- Form validation to ensure at least one expression in complex mode

### Backend Integration
- Reuse existing `/expression` POST endpoint
- Simple expressions send data like:
  ```json
    {
      "expression": { "property": "user_id", "operator": "eq", "value": "123" }
    }
  ```
- Complex expressions send data like:
  ```json
  {
    "expression": {
      "any": [ // or "all"
        {"property": "premium", "operator": "eq", "value": "true"}
        {"property": "user_id", "operator": "eq", "value": "123"},
        {"property": "premium", "operator": "eq", "value": "true"}
      ]
    }
  }
  ```
- Backend constructs appropriate `Any` or `All` expression structure
- Trust-based validation - let errors bubble up from expression building

### Data Flow
1. User fills complex form and submits
2. Frontend serializes to JSON structure above
3. Backend receives data, builds expressions array
4. Backend creates `Flipper.any([...])` or `Flipper.all([...])`
5. Backend enables expression on feature
6. Redirect back to feature page

## Phase Scope
- **In Scope**: Simple any/all groups with multiple simple expressions
- **Out of Scope**: Nested groups (any/all containing other any/all)
- **Out of Scope**: Editing existing complex expressions
- **Out of Scope**: Advanced validation or error handling

## Files to Modify
- `lib/flipper/ui/views/feature.erb` - Add form structure
- `lib/flipper/ui/actions/expression_gate.rb` - Handle complex expression data
- Add minimal JavaScript for dynamic form behavior

## Success Criteria
- User can choose between simple and complex expression types
- User can create any/all groups with multiple simple expressions
- Complex expressions work correctly with existing backend
- Form integrates seamlessly with current UI design
- Trust-based validation approach maintained
