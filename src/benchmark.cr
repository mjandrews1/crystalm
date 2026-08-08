# Package: crystalm
# File:    src/benchmark.cr
# Summary: Performance Benchmarks
#
# SPDX-FileCopyrightText:  2026 Mark J. Andrews
# SPDX-License-Identifier: AGPL-3.0-or-later

# Benchmark result
struct BenchmarkResult
  property name : String
  property iterations : Int64
  property elapsed_ms : Float64
  property ops_per_second : Float64

  def initialize(@name : String, @iterations : Int64, @elapsed_ms : Float64, @ops_per_second : Float64)
  end
end

# Performance benchmark suite
class BenchmarkSuite
  getter results : Array(BenchmarkResult)

  def initialize
    @results = Array(BenchmarkResult).new
  end

  def run_all
    benchmark_database_set
    benchmark_database_get
    benchmark_database_kill
    benchmark_database_order
    benchmark_symbol_set
    benchmark_symbol_get
    benchmark_io
    benchmark_integrated
  end

  private def benchmark_database_set
    iterations = 100000_i64
    db = Database.new

    start = Time.monotonic
    iterations.times do
      db.set("TEST", subscripts: ["sub1"], value: "value")
    end
    finish = Time.monotonic

    elapsed = (finish - start).total_seconds
    ops_per_second = iterations.to_f / elapsed

    @results << BenchmarkResult.new("Database SET", iterations, elapsed * 1000, ops_per_second)
  end

  private def benchmark_database_get
    iterations = 100000_i64
    db = Database.new
    db.set("TEST", subscripts: ["sub1"], value: "value")

    start = Time.monotonic
    iterations.times do
      val = db.get("TEST", subscripts: ["sub1"])
      raise "Assertion failed" unless val == "value"
    end
    finish = Time.monotonic

    elapsed = (finish - start).total_seconds
    ops_per_second = iterations.to_f / elapsed

    @results << BenchmarkResult.new("Database GET", iterations, elapsed * 1000, ops_per_second)
  end

  private def benchmark_database_kill
    iterations = 100000_i64

    start = Time.monotonic
    iterations.times do
      db = Database.new
      db.set("TEST", value: "value")
      db.kill("TEST")
    end
    finish = Time.monotonic

    elapsed = (finish - start).total_seconds
    ops_per_second = iterations.to_f / elapsed

    @results << BenchmarkResult.new("Database KILL", iterations, elapsed * 1000, ops_per_second)
  end

  private def benchmark_database_order
    iterations = 100000_i64
    db = Database.new
    db.set("TEST", subscripts: ["a"], value: "1")
    db.set("TEST", subscripts: ["b"], value: "2")
    db.set("TEST", subscripts: ["c"], value: "3")

    start = Time.monotonic
    iterations.times do
      val = db.order("TEST")
      raise "Assertion failed" unless val == "a"
    end
    finish = Time.monotonic

    elapsed = (finish - start).total_seconds
    ops_per_second = iterations.to_f / elapsed

    @results << BenchmarkResult.new("Database ORDER", iterations, elapsed * 1000, ops_per_second)
  end

  private def benchmark_symbol_set
    iterations = 100000_i64
    table = SymbolTable.new

    start = Time.monotonic
    iterations.times do
      table.set("X", value: "value")
    end
    finish = Time.monotonic

    elapsed = (finish - start).total_seconds
    ops_per_second = iterations.to_f / elapsed

    @results << BenchmarkResult.new("Symbol SET", iterations, elapsed * 1000, ops_per_second)
  end

  private def benchmark_symbol_get
    iterations = 100000_i64
    table = SymbolTable.new
    table.set("X", value: "value")

    start = Time.monotonic
    iterations.times do
      val = table.get("X")
      raise "Assertion failed" unless val == "value"
    end
    finish = Time.monotonic

    elapsed = (finish - start).total_seconds
    ops_per_second = iterations.to_f / elapsed

    @results << BenchmarkResult.new("Symbol GET", iterations, elapsed * 1000, ops_per_second)
  end

  private def benchmark_io
    iterations = 100000_i64
    io = IOManager.new
    io.open(0, "terminal", DeviceType::Terminal)
    io.use(0)

    start = Time.monotonic
    iterations.times do
      io.write("Hello")
    end
    finish = Time.monotonic

    elapsed = (finish - start).total_seconds
    ops_per_second = iterations.to_f / elapsed

    @results << BenchmarkResult.new("IO Write", iterations, elapsed * 1000, ops_per_second)
  end

  private def benchmark_integrated
    iterations = 100000_i64
    rt = IntegratedRuntime.new
    rt.start

    start = Time.monotonic
    iterations.times do
      rt.set_var("X", value: "value")
      val = rt.get_var("X")
      raise "Assertion failed" unless val == "value"
    end
    finish = Time.monotonic

    elapsed = (finish - start).total_seconds
    ops_per_second = iterations.to_f / elapsed

    rt.stop
    @results << BenchmarkResult.new("Integrated Runtime", iterations, elapsed * 1000, ops_per_second)
  end

  def print_results
    puts "Performance Benchmark Results:"
    puts "============================="
    puts
    puts "Benchmark            | Iterations | Time (ms) | Ops/sec"
    puts "---------------------|------------|-----------|--------"
    
    @results.each do |result|
      printf "%-20s | %10d | %9.0f | %10.0f\n", result.name, result.iterations, result.elapsed_ms, result.ops_per_second
    end
  end

  def get_results : Array(BenchmarkResult)
    @results
  end
end
