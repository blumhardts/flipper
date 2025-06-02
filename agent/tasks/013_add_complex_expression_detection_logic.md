# Task 013: Add Complex Expression Detection Logic

## Change-request
Add detection and parsing logic to identify complex expressions (Any/All) and extract their structure for rendering and form population. **References: [Plan 005](../plans/005_complex_expression_rendering_support.md)**

## Steps

### 1. Add complex expression detection method to Feature decorator
- **File**: `lib/flipper/ui/decorators/feature.rb`
- **Location**: Add after `parse_simple_expression` method (around line 172)
- **Add method**: `parse_complex_expression` that yields operator type ("Any" or "All") and array of conditions
- **Logic**: Check for expression structure like `{"Any": [...]}` or `{"All": [...]}`

### 2. Add expression type detection method
- **File**: `lib/flipper/ui/decorators/feature.rb`
- **Location**: Add after `parse_complex_expression` method
- **Add method**: `expression_type` that returns :simple, :complex_any, :complex_all, or :none
- **Logic**: Use existing `parse_simple_expression` and new `parse_complex_expression` to determine type

### 3. Add complex expression condition counting
- **File**: `lib/flipper/ui/decorators/feature.rb`
- **Location**: Add after `expression_type` method
- **Add method**: `complex_expression_condition_count` that returns number of conditions in Any/All
- **Logic**: Parse complex expression and count array elements
