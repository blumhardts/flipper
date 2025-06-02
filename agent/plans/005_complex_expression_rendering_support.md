# Plan 002: Complex Expression Rendering Support

## Overview
Add comprehensive rendering support for complex expressions in the Flipper UI. This includes both text display (read-only summary) and form editing (populating the dynamic form with existing data).

## Current State
- Complex expression creation is implemented with Property/Any/All radio button selection
- Dynamic form allows adding/removing expression rows for Any/All types
- Backend processing handles both simple and complex expression data
- No rendering support exists for displaying or editing existing complex expressions

## Goals
1. **Unified Text Display**: Single rendering system that handles both simple property expressions and complex any/all expressions
2. **Editable Form Population**: Load existing complex expressions back into the dynamic form for editing
3. **Concise Summaries**: Show "Any of 3 conditions" style text rather than verbose listings

## Implementation Areas

### 1. Expression Detection & Routing
- Add logic to determine if an expression is simple property or complex any/all
- Route to appropriate rendering method based on expression type
- Handle edge cases like empty expressions or malformed data

### 2. Text Rendering System
- Refactor existing `expression_summary` and `expression_description` methods in Feature decorator
- Extend current simple expression handling to support complex expression summaries
- Update fallback from "complex expression" to "Any of 3 conditions" / "All of 2 conditions"
- Reuse existing `parse_simple_expression` logic and add `parse_complex_expression` counterpart

### 3. Form Population System
- Parse existing complex expressions back into form data structure
- Populate radio button selection (Property/Any/All) based on expression type
- Load expression rows into dynamic form with correct property/operator/value data

### 4. UI Integration Points
- Replace existing expression display in feature view
- Update form initialization to detect and load existing expressions
- Ensure proper JavaScript state management for pre-populated forms
- Maintain backwards compatibility with simple expression editing

## Success Criteria
- Complex expressions display as concise text summaries
- Existing complex expressions can be edited via the dynamic form
- Simple expressions continue to work unchanged
- Unified display system handles all expression types
- No breaking changes to existing functionality

## Technical Considerations
- Expression parsing logic for detecting type and extracting data
- JavaScript form state management for pre-populated dynamic rows
- Ruby helper methods for text generation and form data preparation
