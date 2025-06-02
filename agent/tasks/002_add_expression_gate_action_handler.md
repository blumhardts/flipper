# Add Expression Gate Action Handler

## Change-request
Create UI action handler for expression gate operations (enable/disable) following the existing API pattern but adapted for web forms. References [plan 001](../plans/001_expression_ui_support_implementation.md).

## Steps

1. **Create ExpressionGate action class**
   - File: `lib/flipper/ui/actions/expression_gate.rb`
   - Inherit from `Flipper::UI::Action`
   - Handle POST (enable) and DELETE (disable) requests
   - Parse form parameters and build expression using `Flipper::Expression.build`

2. **Add expression gate route to action collection**
   - File: `lib/flipper/ui/action_collection.rb`
   - Add route pattern matching `/features/{name}/expression`
   - Register ExpressionGate action class

3. **Handle form parameter parsing**
   - Method in ExpressionGate class
   - Convert HTML form data to expression hash format
   - Support simple property comparisons (property, operator, value)
