# UI Feature CRUD Operations

## Current Feature Management System

### Create
- **Route**: `GET /features/new` → [`lib/flipper/ui/actions/add_feature.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/add_feature.rb)
- **View**: [`lib/flipper/ui/views/add_feature.erb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/views/add_feature.erb)
- **Submit**: `POST /features` → [`lib/flipper/ui/actions/features.rb#L35-L55`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/features.rb#L35-L55)

### Read
- **List**: `GET /features` → [`lib/flipper/ui/actions/features.rb#L11-L33`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/features.rb#L11-L33)
- **Detail**: `GET /features/{name}` → [`lib/flipper/ui/actions/feature.rb#L12-L22`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/feature.rb#L12-L22)
- **View**: [`lib/flipper/ui/views/feature.erb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/views/feature.erb)

### Update (Gate Management)
Current feature view supports editing these gate types:

#### Actors Gate
- **Add**: Form at lines 53-62 in feature.erb → `POST /features/{name}/actors`
- **Remove**: Individual forms at lines 86-93 → `POST /features/{name}/actors`
- **UI**: Toggle-based interface with inline forms

#### Groups Gate  
- **Add**: Dropdown form at lines 122-134 → `POST /features/{name}/groups`
- **Remove**: Individual forms at lines 153-160 → `POST /features/{name}/groups`
- **UI**: Select dropdown for available groups

#### Percentage Gates
- **Percentage of Actors**: Forms at lines 188-202 → `POST /features/{name}/percentage_of_actors`
- **Percentage of Time**: Forms at lines 229-243 → `POST /features/{name}/percentage_of_time`
- **UI**: Button groups for common percentages + custom input

#### Boolean Gate
- **Enable/Disable**: Form at lines 252-288 → `POST /features/{name}/boolean`
- **UI**: Full enable/disable buttons with confirmation

### Delete
- **Route**: `DELETE /features/{name}` → [`lib/flipper/ui/actions/feature.rb#L24-L36`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/feature.rb#L24-L36)
- **UI**: Delete form at lines 304-315 with confirmation prompt
- **Conditional**: Only shown if `Flipper::UI.configuration.feature_removal_enabled`

## Key Patterns
- **CSRF Protection**: All forms include `csrf_input_tag`
- **Confirmation**: Critical actions require feature name confirmation
- **Toggle UI**: JavaScript-powered expand/collapse for forms
- **Permission Checks**: `write_allowed?` guards all modification forms
- **URL Escaping**: Feature names escaped via `Flipper::UI::Util.escape`
