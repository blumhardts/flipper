# Task 015: Add Complex Expression Form Population

## Change-request
Add system to parse existing complex expressions and populate the dynamic form for editing, including radio button selection and expression rows. **References: [Plan 005](../plans/005_complex_expression_rendering_support.md)**

## Steps

### 1. Add complex expression form values method
- **File**: `lib/flipper/ui/decorators/feature.rb`
- **Location**: Add after `expression_form_values` method (around line 146)
- **Add method**: `complex_expression_form_values` that returns hash with type and expressions array
- **Logic**: Parse Any/All expressions into array of {property, operator, value} hashes

### 2. Update expression_form_values method
- **File**: `lib/flipper/ui/decorators/feature.rb`
- **Location**: Modify existing `expression_form_values` method (lines 135-146)
- **Logic**: Add detection for complex expressions and return appropriate data structure
- **Return format**: Include `type` field ("property", "any", "all") and `expressions` array

### 3. Add expression form data helper
- **File**: `lib/flipper/ui/decorators/feature.rb`
- **Location**: Add after updated `expression_form_values` method
- **Add method**: `expression_form_data` that returns complete form initialization data
- **Logic**: Combine type detection with form values for JavaScript consumption
