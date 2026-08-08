# crystalm API Documentation

## Overview

crystalm is a MUMPS (M) implementation written in Crystal. It provides a complete MUMPS runtime environment including:

- Database engine
- Runtime interpreter
- Full MUMPS parser supporting all 22 commands
- Symbol table management
- I/O operations
- Pattern matching

## Core Modules

### Database Engine

#### `database.cr`
Main database module providing global variable storage.

```crystal
require "crystalm"

# Create a database
db = Database.new

# Set data
db.set("GLOBAL", value: "value")
db.set("GLOBAL", subscripts: ["sub1"], value: "value1")

# Get data
value = db.get("GLOBAL")
value1 = db.get("GLOBAL", subscripts: ["sub1"])

# Kill data
db.kill("GLOBAL")

# $DATA
status = db.data("GLOBAL") # 0, 1, 10, 11

# $ORDER
next = db.order("GLOBAL")
```

### Runtime Interpreter

#### `runtime.cr`
Main runtime interpreter.

```crystal
require "crystalm"

# Create runtime
runtime = MumpsRuntime.new

# Variable operations
runtime.set_var("X", value: "42")
value = runtime.get_var("X")
runtime.kill_var("X")

# I/O operations
runtime.write("Hello")
runtime.write_newline

# Get output
output = runtime.get_output
```

### Compiler

#### `lexer.cr`
MUMPS lexer for tokenization.

```crystal
require "crystalm"

# Create lexer
lexer = Lexer.new("SET X = 42")

# Get tokens
token = lexer.next_token
```

#### `parser.cr`
MUMPS parser for AST generation.

```crystal
require "crystalm"

# Create parser
parser = Parser.new("SET X = 42")

# Parse code
ast = parser.parse
```

### Symbol Table

#### `symbol_table.cr`
Symbol table for local variables.

```crystal
require "crystalm"

# Create symbol table
table = SymbolTable.new

# Set/get variables
table.set("X", value: "42")
value = table.get("X")

# Check if variable exists
exists = table.exists?("X")

# Kill variable
table.kill("X")

# Subscripted variables
table.set_subscript("X", subscripts: ["sub1"], value: "value1")
val = table.get_subscript("X", subscripts: ["sub1"])
```

### I/O Operations

#### `io.cr`
I/O operations for devices.

```crystal
require "crystalm"

# Create I/O manager
io = IOManager.new

# Open device
io.open(0, "terminal", DeviceType::Terminal)

# Use device
io.use(0)

# Write data
io.write("Hello")
io.write_newline

# Read data
input = io.read

# Close device
io.close(0)
```

### Pattern Matching

#### `pattern.cr`
MUMPS pattern matching.

```crystal
require "crystalm"

# Pattern matching
match = PatternMatcher.match("123", "3N") # true
match2 = PatternMatcher.match("abc", "3A") # true
match3 = PatternMatcher.match("abc123", "3A3N") # true
```

### Integrated Runtime

#### `integrated.cr`
Integrated runtime connecting all components.

```crystal
require "crystalm"

# Create integrated runtime
rt = IntegratedRuntime.new

# Start execution
rt.start

# Variable operations
rt.set_var("X", value: "42")
value = rt.get_var("X")

# Database operations
rt.set_global("TEST", subscripts: ["sub1"], value: "value1")
val = rt.get_global("TEST", subscripts: ["sub1"])

# I/O operations
rt.write("Hello")
rt.write_newline

# Stop execution
rt.stop
```

### Conformance Tests

#### `conformance.cr`
MUMPS conformance test suite.

```crystal
require "crystalm"

# Create conformance suite
suite = ConformanceSuite.new

# Run all tests
suite.run_all

# Get results
passed = suite.get_pass_count
failed = suite.get_fail_count
```

## Test Suite

### Running Tests

```bash
crystal spec
```

### Test Coverage

The test suite includes 8 test categories:

- Arithmetic operations
- Comparison operations
- String operations
- Variable operations
- Database operations
- Symbol table operations
- I/O operations
- Pattern matching

## Error Handling

All functions that can fail return an optional or raise an error.

```crystal
value = db.get("TEST") # Returns String?
```

## Memory Management

All modules use Crystal's automatic garbage collector.

## Thread Safety

The current implementation is not thread-safe. For multi-threaded usage, external synchronization is required.

## Platform Support

crystalm supports:

- macOS
- Linux
- Windows

## License

AGPL-3.0-or-later
