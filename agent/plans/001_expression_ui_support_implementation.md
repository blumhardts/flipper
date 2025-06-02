# Expression UI Support Implementation

## Goal
Add Expression gate support to the Flipper UI, allowing users to create property-based feature flag rules through a web interface alongside existing actors, groups, and percentage gates.

## Scope
- **In Scope**: Logical (all/any), comparison (eq/gt/lt/gte/lte/ne), and data (property/string/number/boolean) expression types
- **Out of Scope**: Probability expression types, complex nested UI (Phase 2), expression editing (Phase 2)

## Key Requirements

### Configuration System
- Add expression property configuration to `Flipper::UI.configure` block
- Support property definitions with types: `boolean`, `string`, `number`
- Follow existing UI configuration patterns

### UI Integration
- Add expression gate section to feature detail view alongside existing gates
- Use Bootstrap-only styling, no custom CSS
- Minimal vanilla JavaScript, maximum server-side logic
- Handle backend validation errors like existing API pattern

### Technical Approach
- Reuse existing Expression classes and `Flipper::Expression.build()`
- Follow existing gate action patterns (POST to enable, DELETE to disable)
- Server-side expression validation and error handling
- Phase 1: Flat property comparisons only (document nesting need)
- Phase 1: Creation only (document editing need)

## Architecture Decisions
- **Validation**: Backend-only, return errors to UI
- **Complexity**: Start simple, iterate to complex nested expressions
- **Dependencies**: No third-party JS libraries
- **Styling**: Bootstrap classes exclusively
- **Logic Distribution**: Maximum server-side, minimum client-side

## Success Criteria
- Users can configure available properties for expressions
- Users can create simple property-based expressions via UI
- Expressions work alongside existing gate types
- Backend validation prevents invalid expressions
- UI matches existing Flipper UI patterns and styling
