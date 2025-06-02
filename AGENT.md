# Flipper Ruby Gem Development Guide

## Commands
- **Run all tests**: `bundle exec rake` (runs RSpec, Minitest, and Rails tests)
- **Run RSpec tests**: `bundle exec rake spec` or `bundle exec rspec`
- **Run single RSpec test**: `bundle exec rspec spec/path/to/file_spec.rb`
- **Run Minitest tests**: `bundle exec rake test`
- **Run single Minitest**: `bundle exec ruby -Ilib:test test/path/to/file_test.rb`
- **Run Rails tests**: `bundle exec rake test_rails`
- **Build gem**: `bundle exec rake build`
- **Install dependencies**: `bundle install`

## Code Style
- Use 2-space indentation, snake_case for methods/variables, PascalCase for classes/modules
- Require statements at top of file, grouped by standard library, gems, then local files
- Use double quotes for strings, symbol notation `:symbol` vs `'symbol'`
- Method visibility: public methods first, then private/protected at bottom with keywords
- Error handling: prefer explicit rescue blocks, raise specific exception classes
- Comments: use `# Public:` and `# Private:` for method documentation
- Module structure: extend self for module methods, use proper namespacing under Flipper::
- Test style: RSpec with `describe`/`it`, Minitest with class inheritance and `def test_*` methods
- Use `double()` for mocks in RSpec, `prepend` for shared test modules in Minitest

## Agent Directory Structure
The `agent/` directory contains three subdirectories for managing development workflow:

### agent/plans/
High-level feature concepts and planning sessions. Files use autoincrementing number prefix + underscored description (7 words max). Example: `001_expression_ui_support_implementation.md`

### agent/tasks/
Specific implementation tasks broken down from plans. Files use autoincrementing number prefix + underscored description (7 words max). Example: `001_add_expression_gate_action_handler.md`

**Task Structure:**
- **Change-request**: High-level intent and plan reference if applicable
- **Steps**: Precise file and language structure changes needed for completion

### agent/docs/
Current codebase understanding organized by subsystem and context. Named by subsystem + context for easy future reference. Example: `ui_feature_crud_operations.md`, `core_expressions_architecture.md`

**Documentation Guidelines:**
- Reference source files with file links
- Never reference plans or tasks
- Update after each completed task
- Focus on current state, not desired state

## Development Workflow
1. **Planning**: Create high-level concept in agent/plans/
2. **Task Generation**: Break plan into specific tasks in agent/tasks/
3. **Implementation**: Execute task steps
4. **Testing & Verification**: Run tests and verify functionality
5. **Documentation Update**: Update relevant docs in agent/docs/
