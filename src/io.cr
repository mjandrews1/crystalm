# Package: crystalm
# File:    src/io.cr
# Summary: MUMPS I/O Operations
#
# SPDX-FileCopyrightText:  2026 Mark J. Andrews
# SPDX-License-Identifier: AGPL-3.0-or-later

# I/O Device types
enum DeviceType
  Terminal
  File
  Socket
  Pipe
end

# I/O Device
class Device
  property id : Int32
  property name : String
  property type : DeviceType
  property open : Bool
  property input_buffer : String
  property output_buffer : String
  property x : Int32
  property y : Int32

  def initialize(@id : Int32, @name : String, @type : DeviceType)
    @open = false
    @input_buffer = ""
    @output_buffer = ""
    @x = 0
    @y = 0
  end
end

# I/O Manager
class IOManager
  property devices : Hash(Int32, Device)
  property current_device : Int32

  def initialize
    @devices = Hash(Int32, Device).new
    @current_device = 0
  end

  # Open a device
  def open(id : Int32, name : String, type : DeviceType)
    device = Device.new(id, name, type)
    device.open = true
    @devices[id] = device
  end

  # Close a device
  def close(id : Int32)
    @devices.delete(id)
  end

  # Use a device
  def use(id : Int32)
    @current_device = id
  end

  # Write to current device
  def write(data : String)
    return unless device = @devices[@current_device]?
    return unless device.open
    
    device.output_buffer += data
    
    # Update cursor position
    data.each_char do |c|
      if c == '\n'
        device.x = 0
        device.y += 1
      elsif c == '\r'
        device.x = 0
      else
        device.x += 1
      end
    end
  end

  # Write newline
  def write_newline
    write("\n")
  end

  # Write form feed
  def write_form_feed
    write("\u{0C}")
  end

  # Write tab
  def write_tab(col : Int32)
    return unless device = @devices[@current_device]?
    return unless device.open
    while device.x < col
      write(" ")
    end
  end

  # Write star (character)
  def write_star(c : Char)
    write(c.to_s)
  end

  # Read from current device
  def read(timeout : Int32 = 0) : String
    return "" unless device = @devices[@current_device]?
    return "" unless device.open
    
    result = device.input_buffer
    device.input_buffer = ""
    result
  end

  # Read star (single character)
  def read_star(timeout : Int32 = 0) : Char?
    return nil unless device = @devices[@current_device]?
    return nil unless device.open
    
    if first = device.input_buffer[0]?
      device.input_buffer = device.input_buffer[1..]
      return first
    end
    
    nil
  end

  # Add input to device
  def add_input(id : Int32, data : String)
    return unless device = @devices[id]?
    device.input_buffer += data
  end

  # Get output from device
  def get_output(id : Int32) : String
    @devices[id]?.try(&.output_buffer) || ""
  end

  # Clear output
  def clear_output(id : Int32)
    @devices[id]?.try(&.output_buffer = "")
  end

  # Check if device is open
  def open?(id : Int32) : Bool
    @devices[id]?.try(&.open) || false
  end

  # Get current device
  def current_device : Int32
    @current_device
  end

  # Get cursor X position
  def x(id : Int32) : Int32
    @devices[id]?.try(&.x) || 0
  end

  # Get cursor Y position
  def y(id : Int32) : Int32
    @devices[id]?.try(&.y) || 0
  end

  # Set cursor position
  def set_position(id : Int32, x : Int32, y : Int32)
    @devices[id]?.try { |d| d.x = x; d.y = y }
  end

  # Get device mode
  def mode(id : Int32) : DeviceType
    @devices[id]?.try(&.type) || DeviceType::Terminal
  end

  # Set device mode
  def set_mode(id : Int32, mode : DeviceType)
    @devices[id]?.try(&.type = mode)
  end
end
