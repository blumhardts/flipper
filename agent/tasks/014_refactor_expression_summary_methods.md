# Task 014: Refactor Expression Summary Methods

## Change-request
Update existing `expression_summary` and `expression_description` methods to handle complex expressions with concise summaries like "Any of 3 conditions". **References: [Plan 005](../plans/005_complex_expression_rendering_support.md)**

## Steps

### 1. Update expression_summary method
- **File**: `lib/flipper/ui/decorators/feature.rb`
- **Location**: Replace current `expression_summary` method (lines 106-116)
- **Logic**: 
  - Keep existing simple expression handling
  - Replace "complex expression" fallback with complex expression summary
  - Use new detection methods to show "Any of X conditions" or "All of X conditions"

### 2. Update expression_description method
- **File**: `lib/flipper/ui/decorators/feature.rb`
- **Location**: Replace current `expression_description` method (lines 119-131)
- **Logic**:
  - Keep existing simple expression verbose formatting
  - Replace complex expression fallback with detailed summary
  - Show "with any X conditions" or "with all X conditions"
