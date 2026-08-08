# Package: crystalm
# File:    src/database.cr
# Summary: MUMPS Database Engine
#
# SPDX-FileCopyrightText:  2026 Mark J. Andrews
# SPDX-License-Identifier: AGPL-3.0-or-later

# Database entry
class DbEntry
  property key : String
  property value : String
  property children : Hash(String, DbEntry)

  def initialize(@key : String, @value : String = "")
    @children = Hash(String, DbEntry).new
  end
end

# Database
class Database
  property globals : Hash(String, DbEntry)

  def initialize
    @globals = Hash(String, DbEntry).new
  end

  # Set a global variable
  def set(global : String, subscripts : Array(String) = [] of String, value : String)
    if subscripts.empty?
      # Set root value
      if entry = @globals[global]?
        entry.value = value
      else
        entry = DbEntry.new(global, value)
        @globals[global] = entry
      end
    else
      # Set subscripted value
      if entry = @globals[global]?
        set_subscript(entry, subscripts, value)
      else
        entry = DbEntry.new(global)
        @globals[global] = entry
        set_subscript(entry, subscripts, value)
      end
    end
  end

  private def set_subscript(parent : DbEntry, subscripts : Array(String), value : String)
    if subscripts.size == 1
      # Set leaf value
      if entry = parent.children[subscripts[0]]?
        entry.value = value
      else
        entry = DbEntry.new(subscripts[0], value)
        parent.children[subscripts[0]] = entry
      end
    else
      # Traverse
      if entry = parent.children[subscripts[0]]?
        set_subscript(entry, subscripts[1..], value)
      else
        entry = DbEntry.new(subscripts[0])
        parent.children[subscripts[0]] = entry
        set_subscript(entry, subscripts[1..], value)
      end
    end
  end

  # Get a global variable
  def get(global : String, subscripts : Array(String) = [] of String) : String?
    if entry = @globals[global]?
      if subscripts.empty?
        return entry.value.empty? ? nil : entry.value
      else
        return get_subscript(entry, subscripts)
      end
    end
    nil
  end

  private def get_subscript(parent : DbEntry, subscripts : Array(String)) : String?
    if subscripts.size == 1
      if entry = parent.children[subscripts[0]]?
        return entry.value.empty? ? nil : entry.value
      end
    else
      if entry = parent.children[subscripts[0]]?
        return get_subscript(entry, subscripts[1..])
      end
    end
    nil
  end

  # Kill a global variable
  def kill(global : String, subscripts : Array(String) = [] of String)
    if subscripts.empty?
      # Kill entire global
      @globals.delete(global)
    else
      # Kill subscripted
      if entry = @globals[global]?
        kill_subscript(entry, subscripts)
      end
    end
  end

  private def kill_subscript(parent : DbEntry, subscripts : Array(String))
    if subscripts.size == 1
      parent.children.delete(subscripts[0])
    else
      if entry = parent.children[subscripts[0]]?
        kill_subscript(entry, subscripts[1..])
      end
    end
  end

  # $DATA - check variable status
  def data(global : String, subscripts : Array(String) = [] of String) : UInt8
    if entry = @globals[global]?
      if subscripts.empty?
        result = 0_u8
        result += 1 unless entry.value.empty?
        result += 10 unless entry.children.empty?
        return result
      else
        return data_subscript(entry, subscripts)
      end
    end
    0_u8
  end

  private def data_subscript(parent : DbEntry, subscripts : Array(String)) : UInt8
    if subscripts.size == 1
      if entry = parent.children[subscripts[0]]?
        result = 0_u8
        result += 1 unless entry.value.empty?
        result += 10 unless entry.children.empty?
        return result
      end
    else
      if entry = parent.children[subscripts[0]]?
        return data_subscript(entry, subscripts[1..])
      end
    end
    0_u8
  end

  # $ORDER - get next subscript
  def order(global : String, subscripts : Array(String) = [] of String, direction : Int32 = 1) : String?
    if entry = @globals[global]?
      if subscripts.empty?
        return order_children(entry.children, "", direction)
      else
        return order_subscript(entry, subscripts, direction)
      end
    end
    nil
  end

  private def order_subscript(parent : DbEntry, subscripts : Array(String), direction : Int32) : String?
    if subscripts.size == 1
      return order_children(parent.children, subscripts[0], direction)
    else
      if entry = parent.children[subscripts[0]]?
        return order_subscript(entry, subscripts[1..], direction)
      end
    end
    nil
  end

  private def order_children(children : Hash(String, DbEntry), current : String, direction : Int32) : String?
    keys = children.keys.sort
    
    return nil if keys.empty?
    
    if current.empty?
      return direction > 0 ? keys.first : keys.last
    end
    
    keys.each_with_index do |key, i|
      if key == current
        if direction > 0
          return i + 1 < keys.size ? keys[i + 1] : nil
        else
          return i > 0 ? keys[i - 1] : nil
        end
      end
    end
    
    nil
  end
end
