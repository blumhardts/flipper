# Add Expression Gate UI Section

## Change-request
Add expression gate section to feature detail view alongside existing gates (actors, groups, percentages). Use Bootstrap styling and follow existing UI patterns. References [plan 001](../plans/001_expression_ui_support_implementation.md).

## Steps

1. **Add expression gate section to feature view**
   - File: `lib/flipper/ui/views/feature.erb`
   - Insert expression section after percentage gates, before boolean gate
   - Follow existing gate section structure with card-body and toggle patterns

2. **Create expression form for simple comparisons**
   - Add form with dropdowns for property, operator, value
   - Use existing toggle-container pattern for show/hide
   - Include CSRF protection and proper form action

3. **Display current expression state**
   - Show active expression in human-readable format
   - Add remove functionality for existing expressions
   - Handle case when no expression is set

4. **Add feature decorator support for expressions**
   - File: `lib/flipper/ui/decorators/feature.rb`
   - Add methods to support expression display and formatting
   - Follow existing decorator patterns for other gate types
