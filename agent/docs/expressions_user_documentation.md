# Expressions User Documentation

## Overview
Flipper Expressions are a powerful way to enable features using complex logic based on actor properties and feature context. They are language-agnostic, stored in JSON, and sync between applications and Flipper Cloud.

**Status**: Experimental feature subject to change

## Basic Concepts

### Property-Based Evaluation
Expressions extract properties from actors via the `flipper_properties` method and evaluate conditions against them.

**Example**: Enable feature for users age 21 or older
```ruby
must_be_21 = Flipper.property(:age).gte(21)
Flipper.enable :night_club, must_be_21

# Testing
Flipper.enabled? :night_club, User.new(age: 18) #=> false
Flipper.enabled? :night_club, User.new(age: 21) #=> true
```

### Comparison Operators
Available comparison operators:
- `eq` - equal to
- `gt` - greater than
- `lt` - less than
- `gte` - greater than or equal to
- `lte` - less than or equal to
- `ne` - not equal to

## Combining Expressions

### Logical Grouping
Use `all` (AND) and `any` (OR) to combine multiple expressions:

```ruby
over_21 = Flipper.property(:age).gte(21)
paid = Flipper.property(:paid).eq(true)
vip = Flipper.property(:vip).eq(true)

# Must be over 21 AND (paid OR vip)
Flipper.enable :night_club, Flipper.all(over_21, Flipper.any(paid, vip))
```

### Nested Logic
Groups can be nested to create complex rules with any number of sub-expressions.

## Actor Requirements

### flipper_properties Method
Actors must respond to `flipper_properties` and return a hash of properties:

```ruby
class User < Struct.new(:id, :flipper_properties)
  include Flipper::Identifier
end

basic_user = User.new(1, {"plan" => "basic", "age" => 30})
premium_user = User.new(2, {"plan" => "premium", "age" => 40})
```

**Note**: ActiveRecord models have this method defined by default.

## Additional Resources
- [examples/expressions.rb](https://github.com/flippercloud/flipper/blob/main/examples/expressions.rb) - Comprehensive code samples
- User feedback encouraged via support@flippercloud.io
