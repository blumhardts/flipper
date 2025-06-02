# Expression Editing Support

## Goal
Add expression editing functionality to the Flipper UI by pre-populating the expression form with current values for simple expressions. This allows users to modify existing expressions instead of only creating new ones.

## Scope
- **In Scope**: Pre-populate form fields for simple property comparison expressions
- **Out of Scope**: Complex nested expressions (all/any) - these will show empty form as fallback

## Key Requirements

### Expression Parsing
- Reuse existing logic from `expression_summary` and `expression_description` methods
- Parse simple expressions in format: `{"Equal": [{"Property": ["plan"]}, "basic"]}`
- Extract property name, operator, and value from current expression
- Fall back to empty form for complex expressions

### Form Pre-population
- Pre-select property dropdown with current property (even if not in current config)
- Pre-select operator dropdown with current operator
- Pre-fill value input with current value
- Leave all fields empty for complex expressions or parsing failures

### User Experience
- Same "Edit" button behavior - shows form when clicked
- Same form styling and validation as creation
- Same POST operation replaces existing expression (no separate edit endpoint)
- No mode indicators - editing looks identical to creation

### Technical Approach
- Add new decorator method to extract form values from expression
- Modify UI view to pre-populate form fields when editing
- Reuse existing action handler without modifications
- Handle edge cases gracefully (missing properties, invalid expressions)

## Implementation Strategy

### Step 1: Add Expression Parsing to Decorator
Add method to extract form values (property, operator, value) from current expression:
- Return hash with parsed values for simple expressions  
- Return nil/empty for complex expressions
- Handle all error cases gracefully

### Step 2: Modify UI Form
Update expression form in `feature.erb` to:
- Pre-populate dropdowns and input when editing
- Show current property in dropdown even if not in config
- Fall back to empty form when no values available

### Step 3: Test Edge Cases
Ensure graceful handling of:
- Complex expressions (all/any operators)
- Invalid expression formats
- Properties not in current configuration
- Missing or malformed expression data

## Success Criteria
- Simple expressions pre-populate form fields correctly
- Complex expressions show empty form (fallback behavior)
- Editing uses same validation and error handling as creation
- Properties not in current config still appear in form
- All existing functionality preserved
