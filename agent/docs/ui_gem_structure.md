# UI Gem Structure

## Directory Organization
```
lib/flipper/ui/
├── actions/          # Route handlers (controllers)
├── configuration/    # UI configuration modules  
├── decorators/       # Feature presentation logic
├── public/           # Static assets (CSS, JS, images)
├── views/            # ERB templates
├── action.rb         # Base action class
├── action_collection.rb  # Action routing
├── configuration.rb  # Main config class
├── error.rb          # UI-specific errors
├── middleware.rb     # Rack middleware
├── util.rb           # Utility methods
└── sources.json      # Asset manifest
```

## Actions (Route Handlers)
- [`actors_gate.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/actors_gate.rb) - Manage actor-specific enablement
- [`add_feature.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/add_feature.rb) - Feature creation form/logic
- [`boolean_gate.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/boolean_gate.rb) - Full enable/disable
- [`export.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/export.rb) - Export feature configurations
- [`feature.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/feature.rb) - Individual feature view/delete
- [`features.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/features.rb) - Feature list/create
- [`groups_gate.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/groups_gate.rb) - Group-based enablement
- [`home.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/home.rb) - Dashboard/root
- [`import.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/import.rb) - Import feature configurations
- [`percentage_of_actors_gate.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/percentage_of_actors_gate.rb) - Actor percentage rollouts
- [`percentage_of_time_gate.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/percentage_of_time_gate.rb) - Time percentage rollouts
- [`settings.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/actions/settings.rb) - UI configuration

## Action Pattern
Each action inherits from [`Action`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/action.rb) and handles:
- HTTP method routing (GET/POST/DELETE) 
- Parameter validation
- Flipper adapter interaction
- View rendering or redirects
- Error handling

## Configuration System
- [`configuration.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/configuration.rb) - Main config with defaults
- [`configuration/`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/configuration/) - Modular config components
- Customizable: banners, confirmations, feature removal, etc.

## View Layer
- ERB templates in [`views/`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/ui/views/)
- Bootstrap-based responsive design
- CSRF protection throughout
- JavaScript for toggle/expand behavior

## Key Classes
- **Middleware**: Rack middleware for serving UI
- **ActionCollection**: Routes requests to appropriate actions
- **Decorators**: Add presentation logic to core Flipper objects
- **Util**: Helper methods for escaping, sanitization, etc.
