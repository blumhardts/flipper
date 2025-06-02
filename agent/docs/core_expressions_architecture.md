# Core Expressions Architecture

## Overview
Flipper expressions are composable logical constructs that evaluate to boolean values for feature flag decisions. They support property-based evaluation, comparisons, logical operations, and percentage-based rollouts.

## Core Files
- [`lib/flipper/expression.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/expression.rb) - Main Expression class with builder pattern
- [`lib/flipper/expression/builder.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/expression/builder.rb) - DSL builder methods  
- [`lib/flipper/expression/constant.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/expression/constant.rb) - Constant value wrapper
- [`lib/flipper/gates/expression.rb`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/gates/expression.rb) - Expression gate for feature evaluation
- [`lib/flipper/expressions/`](file:///Users/samblumhardt/Developer/flipper/lib/flipper/expressions/) - 19 specific expression types

## Expression Types
Available expression types include:
- **Logical**: `all`, `any`, `boolean` 
- **Comparison**: `equal`, `not_equal`, `greater_than`, `greater_than_or_equal_to`, `less_than`, `less_than_or_equal_to`
- **Data**: `property`, `string`, `number`, `duration`, `time`, `now`
- **Probability**: `percentage`, `percentage_of_actors`, `random`

## Builder Pattern
The `Expression.build()` method converts various input formats:
- Hash: `{"equal" => ["property", "user_id", "123"]}` → Expression instance
- Primitives: Strings, numbers, booleans → Constant wrapper
- Existing expressions: Pass through unchanged

## Evaluation
Expressions evaluate with context: `expression.evaluate(context)` where context contains properties and values needed for evaluation.

## Structure
Each expression has:
- `name`: String identifier for the expression type
- `function`: Class from `Flipper::Expressions` namespace
- `args`: Array of child expressions/constants
- `value`: Hash representation for serialization
