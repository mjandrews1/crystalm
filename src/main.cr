# Package: crystalm
# File:    src/main.cr
# Summary: M/MUMPS in Crystal - A port of RFC to Crystal language
#
# SPDX-FileCopyrightText:  2026 Mark J. Andrews
# SPDX-License-Identifier: AGPL-3.0-or-later

# MUMPS Runtime
class MumpsRuntime
  property variables : Hash(String, String)
  property running : Bool

  def initialize
    @variables = Hash(String, String).new
    @running = false
  end

  def start
    @running = true
  end

  def stop
    @running = false
  end

  def running? : Bool
    @running
  end

  def set_var(name : String, value : String)
    @variables[name] = value
  end

  def get_var(name : String) : String?
    @variables[name]?
  end

  def kill_var(name : String)
    @variables.delete(name)
  end

  def has_var?(name : String) : Bool
    @variables.has_key?(name)
  end
end

# MUMPS Interpreter
class MumpsInterpreter
  def initialize(@runtime : MumpsRuntime)
  end

  def execute(code : String)
    parts = code.split(" ")
    return if parts.empty?

    command = parts[0].upcase

    case command
    when "SET"
      execute_set(parts[1..])
    when "WRITE"
      execute_write(parts[1..])
    when "KILL"
      execute_kill(parts[1..])
    when "HALT"
      @runtime.stop
    else
      puts "Unknown command: #{command}"
    end
  end

  private def execute_set(args : Array(String))
    return if args.size < 2
    name = args[0]
    value = args[1]
    @runtime.set_var(name, value)
  end

  private def execute_write(args : Array(String))
    args.each do |arg|
      if arg[0] == '"'
        # String literal
        print arg[1..-2]
      else
        # Variable
        print @runtime.get_var(arg) || ""
      end
    end
  end

  private def execute_kill(args : Array(String))
    args.each do |arg|
      @runtime.kill_var(arg)
    end
  end
end

# Main entry point
puts "crystalm - M/MUMPS in Crystal"
puts "A port of RFC to Crystal language"
puts

# Create runtime
runtime = MumpsRuntime.new
runtime.start

# Create interpreter
interpreter = MumpsInterpreter.new(runtime)

# Test basic operations
puts "Testing MUMPS operations:"
puts "========================"

# SET
interpreter.execute("SET X 42")
interpreter.execute("SET NAME John")

# WRITE
interpreter.execute("WRITE X")
puts
interpreter.execute("WRITE NAME")
puts

# Test $DATA
puts
puts "Variable X exists: #{runtime.has_var?("X")}"
puts "Variable Y exists: #{runtime.has_var?("Y")}"

# KILL
interpreter.execute("KILL X")
puts "After KILL X: #{runtime.get_var("X")}"

puts
puts "crystalm is ready for MUMPS development!"
