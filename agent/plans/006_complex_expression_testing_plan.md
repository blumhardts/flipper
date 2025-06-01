# Plan 006: Complex Expression Testing Plan

## Overview
Comprehensive test plan for validating complex expression functionality including creation, editing, deletion, and edge cases for both simple and complex expressions.

## Test Environment Setup
- Ensure `Flipper::UI.expression_properties` is configured with test properties
- Create test feature flags for isolated testing
- Verify UI is accessible and JavaScript is enabled

## Core Functionality Tests

### 1. Simple Expression Lifecycle
**Test ID**: SIMPLE-001 to SIMPLE-003

#### SIMPLE-001: Create Simple Expression
1. Navigate to feature page
2. Click "Add an expression" 
3. Verify "Property" radio button is selected by default
4. Select property from dropdown
5. Select operator (equals, not equal, etc.)
6. Enter test value
7. Click "Save"
8. **Expected**: Expression saved, page shows "Enabled for actors with [property] [operator] [value]"

#### SIMPLE-002: Edit Simple Expression  
1. Start with existing simple expression
2. Click "Edit" on expression section
3. Verify form pre-populated with existing values
4. Modify property/operator/value
5. Click "Save"
6. **Expected**: Expression updated, display reflects changes

#### SIMPLE-003: Delete Simple Expression
1. Start with existing simple expression
2. Click "Edit" on expression section  
3. Click "Remove" button
4. **Expected**: Expression deleted, display shows "No expression enabled"

### 2. Complex Any Expression Lifecycle
**Test ID**: ANY-001 to ANY-003

#### ANY-001: Create Complex Any Expression
1. Navigate to feature page
2. Click "Add an expression"
3. Select "Any" radio button
4. Click "Add Expression" to create first condition
5. Fill in property/operator/value for first condition
6. Click "Add Expression" to create second condition  
7. Fill in property/operator/value for second condition
8. Click "Save"
9. **Expected**: Expression saved, display shows "Enabled for actors with any 2 conditions"

#### ANY-002: Edit Complex Any Expression
1. Start with existing Any expression (2+ conditions)
2. Click "Edit" on expression section
3. Verify "Any" radio button is selected
4. Verify all condition rows are pre-populated
5. Modify values in existing rows
6. Add new condition row
7. Remove one condition row
8. Click "Save"
9. **Expected**: Expression updated with modifications

#### ANY-003: Delete Complex Any Expression
1. Start with existing Any expression
2. Click "Edit" on expression section
3. Click "Remove" button (main remove, not row remove)
4. **Expected**: Entire expression deleted

### 3. Complex All Expression Lifecycle  
**Test ID**: ALL-001 to ALL-003

#### ALL-001: Create Complex All Expression
1. Navigate to feature page
2. Click "Add an expression"
3. Select "All" radio button
4. Create multiple conditions (similar to ANY-001)
5. Click "Save"
6. **Expected**: Expression saved, display shows "Enabled for actors with all X conditions"

#### ALL-002: Edit Complex All Expression
1. Follow similar steps to ANY-002 but with All expression
2. **Expected**: All expression modifications work correctly

#### ALL-003: Delete Complex All Expression
1. Follow similar steps to ANY-003
2. **Expected**: All expression deletion works correctly

## Edge Cases & Data Scenarios

### 4. Empty and Single Condition Tests
**Test ID**: EDGE-001 to EDGE-003

#### EDGE-001: Empty Complex Expression
1. Create Any/All expression with no conditions
2. Try to save
3. **Expected**: Validation prevents saving empty complex expressions

#### EDGE-002: Single Condition Complex vs Simple
1. Create Any expression with 1 condition
2. Create simple expression with same property/operator/value
3. **Expected**: Both work, display shows "any 1 condition" vs property display

#### EDGE-003: Minimum Row Validation
1. Create complex expression with 2 conditions
2. Try to remove all rows
3. **Expected**: Remove button disabled when only 1 row remains

### 5. Property Configuration Changes
**Test ID**: CONFIG-001 to CONFIG-002

#### CONFIG-001: Removed Property Handling
1. Create expression with property "test_prop" 
2. Remove "test_prop" from `Flipper::UI.expression_properties`
3. Navigate to feature page
4. **Expected**: Shows "test_prop (no longer available)" in dropdown

#### CONFIG-002: Property Reconfiguration
1. Start with expression using property A
2. Edit expression after property A config changes
3. **Expected**: Form loads correctly, handles config changes gracefully

### 6. Malformed Data Handling
**Test ID**: DATA-001 to DATA-002

#### DATA-001: Corrupted Expression Data
1. Manually set invalid expression data in adapter
2. Navigate to feature page
3. **Expected**: UI handles gracefully, shows fallback text, doesn't crash

#### DATA-002: Missing Expression Components  
1. Create expression with missing property/operator/value
2. Check UI display and edit behavior
3. **Expected**: UI handles missing data without errors

## UI/UX Scenarios

### 7. Form Interaction Tests
**Test ID**: UI-001 to UI-005

#### UI-001: Radio Button Switching
1. Start creating Any expression with multiple rows
2. Switch to "All" radio button
3. Switch to "Property" radio button
4. Switch back to "Any"
5. **Expected**: Form sections show/hide correctly, no JavaScript errors

#### UI-002: Dynamic Row Management
1. Create complex expression
2. Add 5 expression rows rapidly
3. Remove rows in different order
4. **Expected**: Row numbering updates correctly, remove buttons work

#### UI-003: Add Expression Button States
1. Select "Property" type
2. **Expected**: "Add Expression" button disabled
3. Select "Any" type  
4. **Expected**: "Add Expression" button enabled

#### UI-004: Form Pre-population Accuracy
1. Create complex expression with mixed operators/properties
2. Save and return to edit
3. **Expected**: All dropdowns and inputs exactly match saved data

#### UI-005: Form Validation Feedback
1. Try to submit with empty required fields
2. **Expected**: Clear validation messages, no silent failures

## Integration & Round-trip Tests

### 8. Persistence and Display Tests
**Test ID**: PERSIST-001 to PERSIST-003

#### PERSIST-001: Complex Expression Round-trip
1. Create complex Any expression: user_id=123 OR premium=true
2. Save and navigate away
3. Return to feature page
4. **Expected**: Display shows "any 2 conditions"
5. Edit expression
6. **Expected**: Form shows exact original conditions

#### PERSIST-002: Mixed Gate Types
1. Enable feature for 50% of actors
2. Add complex expression
3. Enable specific actors
4. **Expected**: All gate types display correctly together

#### PERSIST-003: Expression Summary Consistency
1. Create various expression types
2. Check summary in feature list vs feature detail
3. **Expected**: Summaries consistent across all UI views

## Error Handling

### 9. Network and Validation Tests
**Test ID**: ERROR-001 to ERROR-003

#### ERROR-001: Server Validation Errors
1. Submit expression with invalid data (if server validates)
2. **Expected**: Error displayed clearly, form preserves user input

#### ERROR-002: Network Failure Handling
1. Submit form while disconnected
2. **Expected**: Graceful error handling, no data loss

#### ERROR-003: JavaScript Failure Scenarios
1. Disable JavaScript
2. Try to use complex expression forms
3. **Expected**: Basic functionality still works or clear error message

## Performance & Scale Tests

### 10. Load and Performance Tests
**Test ID**: PERF-001 to PERF-002

#### PERF-001: Many Conditions Performance
1. Create complex expression with 20+ conditions
2. Edit and save
3. **Expected**: Reasonable performance, no UI lag

#### PERF-002: Rapid Form Interactions
1. Rapidly add/remove expression rows
2. Quickly switch between radio button types
3. **Expected**: UI remains responsive, no JavaScript errors

## Browser Compatibility

### 11. Cross-browser Tests
**Test ID**: BROWSER-001

#### BROWSER-001: Core Browser Support
1. Test core functionality in Chrome, Firefox, Safari, Edge
2. **Expected**: Consistent behavior across supported browsers

## Success Criteria
- All test scenarios pass without blocking issues
- No JavaScript console errors during normal usage
- Expression data persists accurately through create/edit/save cycles
- UI remains responsive under normal load conditions
- Error conditions are handled gracefully
- Display text matches saved expression data consistently

## Test Data Cleanup
- Remove test feature flags after testing
- Reset expression properties configuration if modified
- Clear any test data from adapters
