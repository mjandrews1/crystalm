# Package: crystalm
# File:    src/integrated.cr
# Summary: Integrated MUMPS Runtime
#
# SPDX-FileCopyrightText:  2026 Mark J. Andrews
# SPDX-License-Identifier: AGPL-3.0-or-later

# Integrated MUMPS Runtime
class IntegratedRuntime
  # Components
  getter database : Database
  getter symbol_table : SymbolTable
  getter io_manager : IOManager

  # Execution state
  getter running : Bool
  getter error_code : Int32
  getter error_message : String

  # Performance counters
  getter instruction_count : Int64
  getter variable_access_count : Int64
  getter io_operation_count : Int64

  def initialize
    @database = Database.new
    @symbol_table = SymbolTable.new
    @io_manager = IOManager.new
    @running = false
    @error_code = 0
    @error_message = ""
    @instruction_count = 0_i64
    @variable_access_count = 0_i64
    @io_operation_count = 0_i64
  end

  # Start execution
  def start
    @running = true
  end

  # Stop execution
  def stop
    @running = false
  end

  # Check if running
  def running? : Bool
    @running
  end

  # Variable operations

  # SET variable
  def set_var(name : String, value : String)
    @variable_access_count += 1
    @symbol_table.set(name, value)
  end

  # GET variable
  def get_var(name : String) : String?
    @variable_access_count += 1
    @symbol_table.get(name)
  end

  # KILL variable
  def kill_var(name : String)
    @variable_access_count += 1
    @symbol_table.kill(name)
  end

  # Check if variable exists
  def has_var?(name : String) : Bool
    @variable_access_count += 1
    @symbol_table.exists?(name)
  end

  # Database operations

  # SET global variable
  def set_global(name : String, subscripts : Array(String) = [] of String, value : String)
    @variable_access_count += 1
    @database.set(name, subscripts, value)
  end

  # GET global variable
  def get_global(name : String, subscripts : Array(String) = [] of String) : String?
    @variable_access_count += 1
    @database.get(name, subscripts)
  end

  # KILL global variable
  def kill_global(name : String, subscripts : Array(String) = [] of String)
    @variable_access_count += 1
    @database.kill(name, subscripts)
  end

  # $DATA global variable
  def data_global(name : String, subscripts : Array(String) = [] of String) : UInt8
    @variable_access_count += 1
    @database.data(name, subscripts)
  end

  # $ORDER global variable
  def order_global(name : String, subscripts : Array(String) = [] of String, direction : Int32 = 1) : String?
    @variable_access_count += 1
    @database.order(name, subscripts, direction)
  end

  # I/O operations

  # WRITE output
  def write(data : String)
    @io_operation_count += 1
    @io_manager.write(data)
  end

  # WRITE newline
  def write_newline
    @io_operation_count += 1
    @io_manager.write_newline
  end

  # WRITE form feed
  def write_form_feed
    @io_operation_count += 1
    @io_manager.write_form_feed
  end

  # READ input
  def read(timeout : Int32 = 0) : String
    @io_operation_count += 1
    @io_manager.read(timeout)
  end

  # Get output
  def get_output(id : Int32) : String
    @io_manager.get_output(id)
  end

  # Clear output
  def clear_output(id : Int32)
    @io_manager.clear_output(id)
  end

  # Error handling

  # Set error
  def set_error(code : Int32, message : String)
    @error_code = code
    @error_message = message
  end

  # Get error code
  def get_error_code : Int32
    @error_code
  end

  # Get error message
  def get_error_message : String
    @error_message
  end

  # Clear error
  def clear_error
    @error_code = 0
    @error_message = ""
  end

  # Performance counters

  # Get instruction count
  def get_instruction_count : Int64
    @instruction_count
  end

  # Get variable access count
  def get_variable_access_count : Int64
    @variable_access_count
  end

  # Get I/O operation count
  def get_io_operation_count : Int64
    @io_operation_count
  end

  # Increment instruction count
  def increment_instruction_count
    @instruction_count += 1
  end

  # MUMPS operations

  # Execute SET command
  def execute_set(name : String, value : String)
    increment_instruction_count
    set_var(name, value)
  end

  # Execute WRITE command
  def execute_write(data : String)
    increment_instruction_count
    write(data)
  end

  # Execute WRITE with newline
  def execute_write_newline
    increment_instruction_count
    write_newline
  end

  # Execute IF command
  def execute_if(condition : Bool) : Bool
    increment_instruction_count
    condition
  end

  # Execute KILL command
  def execute_kill(name : String)
    increment_instruction_count
    kill_var(name)
  end

  # Execute QUIT command
  def execute_quit
    increment_instruction_count
    stop
  end

  # Execute HALT command
  def execute_halt
    increment_instruction_count
    stop
  end
end
