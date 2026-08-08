# Package: crystalm
# File:    src/conformance.cr
# Summary: MUMPS Conformance Tests
#
# SPDX-FileCopyrightText:  2026 Mark J. Andrews
# SPDX-License-Identifier: AGPL-3.0-or-later

# Test result
struct TestResult
  property name : String
  property passed : Bool
  property message : String

  def initialize(@name : String, @passed : Bool = true, @message : String = "")
  end
end

# Conformance test suite
class ConformanceSuite
  getter results : Array(TestResult)
  getter passed : UInt32
  getter failed : UInt32

  def initialize
    @results = Array(TestResult).new
    @passed = 0_u32
    @failed = 0_u32
  end

  def run_all
    test_arithmetic
    test_comparison
    test_string
    test_variables
    test_database
    test_symbol_table
    test_io
    test_pattern_matching
  end

  private def test_arithmetic
    result = TestResult.new("Arithmetic Operations")

    # Test addition
    if 1 + 2 != 3
      result = TestResult.new("Arithmetic Operations", false, "Addition failed")
    end

    # Test subtraction
    if 5 - 3 != 2
      result = TestResult.new("Arithmetic Operations", false, "Subtraction failed")
    end

    # Test multiplication
    if 4 * 5 != 20
      result = TestResult.new("Arithmetic Operations", false, "Multiplication failed")
    end

    # Test division
    if 10 / 2 != 5
      result = TestResult.new("Arithmetic Operations", false, "Division failed")
    end

    # Test modulus
    if 10 % 3 != 1
      result = TestResult.new("Arithmetic Operations", false, "Modulus failed")
    end

    add_result(result)
  end

  private def test_comparison
    result = TestResult.new("Comparison Operations")

    # Test equal
    if !(1 == 1)
      result = TestResult.new("Comparison Operations", false, "Equal failed")
    end

    # Test not equal
    if !(1 != 2)
      result = TestResult.new("Comparison Operations", false, "Not equal failed")
    end

    # Test less than
    if !(1 < 2)
      result = TestResult.new("Comparison Operations", false, "Less than failed")
    end

    # Test greater than
    if !(2 > 1)
      result = TestResult.new("Comparison Operations", false, "Greater than failed")
    end

    add_result(result)
  end

  private def test_string
    result = TestResult.new("String Operations")

    # Test concatenation
    str1 = "Hello"
    str2 = " World"
    concat = str1 + str2
    if concat != "Hello World"
      result = TestResult.new("String Operations", false, "Concatenation failed")
    end

    # Test length
    if str1.size != 5
      result = TestResult.new("String Operations", false, "Length failed")
    end

    add_result(result)
  end

  private def test_variables
    result = TestResult.new("Variable Operations")

    # Test basic variable
    x = 42
    if x != 42
      result = TestResult.new("Variable Operations", false, "Variable assignment failed")
    end

    # Test variable modification
    x = 100
    if x != 100
      result = TestResult.new("Variable Operations", false, "Variable modification failed")
    end

    add_result(result)
  end

  private def test_database
    result = TestResult.new("Database Operations")

    db = Database.new

    # Test set and get
    db.set("TEST", value: "value")
    if db.get("TEST") != "value"
      result = TestResult.new("Database Operations", false, "Database set/get failed")
    end

    # Test subscripted
    db.set("TEST", subscripts: ["sub1"], value: "value1")
    if db.get("TEST", subscripts: ["sub1"]) != "value1"
      result = TestResult.new("Database Operations", false, "Database subscripted set/get failed")
    end

    # Test $DATA
    if db.data("TEST") != 11
      result = TestResult.new("Database Operations", false, "Database $DATA failed")
    end

    # Test kill
    db.kill("TEST")
    if db.get("TEST") != nil
      result = TestResult.new("Database Operations", false, "Database kill failed")
    end

    add_result(result)
  end

  private def test_symbol_table
    result = TestResult.new("Symbol Table Operations")

    table = SymbolTable.new

    # Test set and get
    table.set("X", value: "42")
    if table.get("X") != "42"
      result = TestResult.new("Symbol Table Operations", false, "Symbol table set/get failed")
    end

    # Test exists
    if !table.exists?("X")
      result = TestResult.new("Symbol Table Operations", false, "Symbol table exists failed")
    end

    # Test kill
    table.kill("X")
    if table.exists?("X")
      result = TestResult.new("Symbol Table Operations", false, "Symbol table kill failed")
    end

    add_result(result)
  end

  private def test_io
    result = TestResult.new("I/O Operations")

    io = IOManager.new

    # Test open
    io.open(0, "terminal", DeviceType::Terminal)
    if !io.open?(0)
      result = TestResult.new("I/O Operations", false, "I/O open failed")
    end

    # Test write
    io.use(0)
    io.write("Hello")
    if io.get_output(0) != "Hello"
      result = TestResult.new("I/O Operations", false, "I/O write failed")
    end

    # Test close
    io.close(0)
    if io.open?(0)
      result = TestResult.new("I/O Operations", false, "I/O close failed")
    end

    add_result(result)
  end

  private def test_pattern_matching
    result = TestResult.new("Pattern Matching")

    # Test numeric pattern
    if !PatternMatcher.match("123", "3N")
      result = TestResult.new("Pattern Matching", false, "Numeric pattern failed")
    end

    # Test alpha pattern
    if !PatternMatcher.match("abc", "3A")
      result = TestResult.new("Pattern Matching", false, "Alpha pattern failed")
    end

    # Test mixed pattern
    if !PatternMatcher.match("abc123", "3A3N")
      result = TestResult.new("Pattern Matching", false, "Mixed pattern failed")
    end

    add_result(result)
  end

  private def add_result(result : TestResult)
    if result.passed
      @passed += 1
    else
      @failed += 1
    end
    @results << result
  end

  def get_pass_count : UInt32
    @passed
  end

  def get_fail_count : UInt32
    @failed
  end

  def get_total_count : UInt32
    @passed + @failed
  end
end
