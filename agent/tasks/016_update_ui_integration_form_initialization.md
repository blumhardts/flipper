# Task 016: Update UI Integration Form Initialization

## Change-request
Update the feature view and JavaScript to use new form population system for loading existing expressions into the dynamic form interface. **References: [Plan 005](../plans/005_complex_expression_rendering_support.md)**

## Steps

### 1. Update feature view to pass form data
- **File**: `lib/flipper/ui/views/feature.erb`
- **Location**: Around line 285 where expression form begins
- **Add**: Data attribute or JavaScript variable with expression form data from decorator
- **Logic**: Use `expression_form_data` method to provide initial form state

### 2. Update JavaScript form initialization
- **File**: `lib/flipper/ui/public/js/application.js`
- **Location**: Around line 180 in expression form handling section
- **Add**: Form population logic that reads initial data and populates form
- **Logic**: 
  - Set radio button selection based on expression type
  - Populate simple form for property expressions
  - Create dynamic rows for complex expressions
  - Disable/enable appropriate form sections

### 3. Update JavaScript state management
- **File**: `lib/flipper/ui/public/js/application.js`
- **Location**: In existing expression form event handlers
- **Logic**: Ensure form switching and validation work correctly with pre-populated data
- **Test**: Form should maintain state when switching between types with existing data
