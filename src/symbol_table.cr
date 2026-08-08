# Package: crystalm
# File:    src/symbol_table.cr
# Summary: MUMPS Symbol Table
#
# SPDX-FileCopyrightText:  2026 Mark J. Andrews
# SPDX-License-Identifier: AGPL-3.0-or-later

# Symbol table entry
class SymbolEntry
  property name : String
  property value : String
  property subscripts : Hash(String, SymbolEntry)
  property usage : Int32

  def initialize(@name : String, @value : String = "")
    @subscripts = Hash(String, SymbolEntry).new
    @usage = 0
  end
end

# Symbol table
class SymbolTable
  property entries : Hash(String, SymbolEntry)

  def initialize
    @entries = Hash(String, SymbolEntry).new
  end

  # Set a variable
  def set(name : String, value : String)
    if entry = @entries[name]?
      entry.value = value
    else
      entry = SymbolEntry.new(name, value)
      entry.usage = 1
      @entries[name] = entry
    end
  end

  # Get a variable
  def get(name : String) : String?
    if entry = @entries[name]?
      return entry.value.empty? ? nil : entry.value
    end
    nil
  end

  # Check if variable exists
  def exists?(name : String) : Bool
    @entries.has_key?(name)
  end

  # Kill a variable
  def kill(name : String)
    @entries.delete(name)
  end

  # Set subscripted variable
  def set_subscript(name : String, subscripts : Array(String), value : String)
    if entry = @entries[name]?
      set_subscript_entry(entry, subscripts, value)
    else
      entry = SymbolEntry.new(name)
      entry.usage = 1
      @entries[name] = entry
      set_subscript_entry(entry, subscripts, value)
    end
  end

  private def set_subscript_entry(parent : SymbolEntry, subscripts : Array(String), value : String)
    if subscripts.size == 1
      if entry = parent.subscripts[subscripts[0]]?
        entry.value = value
      else
        entry = SymbolEntry.new(subscripts[0], value)
        parent.subscripts[subscripts[0]] = entry
      end
    else
      if entry = parent.subscripts[subscripts[0]]?
        set_subscript_entry(entry, subscripts[1..], value)
      else
        entry = SymbolEntry.new(subscripts[0])
        parent.subscripts[subscripts[0]] = entry
        set_subscript_entry(entry, subscripts[1..], value)
      end
    end
  end

  # Get subscripted variable
  def get_subscript(name : String, subscripts : Array(String)) : String?
    if entry = @entries[name]?
      return get_subscript_entry(entry, subscripts)
    end
    nil
  end

  private def get_subscript_entry(parent : SymbolEntry, subscripts : Array(String)) : String?
    if subscripts.size == 1
      if entry = parent.subscripts[subscripts[0]]?
        return entry.value.empty? ? nil : entry.value
      end
    else
      if entry = parent.subscripts[subscripts[0]]?
        return get_subscript_entry(entry, subscripts[1..])
      end
    end
    nil
  end

  # Kill subscripted variable
  def kill_subscript(name : String, subscripts : Array(String))
    if entry = @entries[name]?
      kill_subscript_entry(entry, subscripts)
    end
  end

  private def kill_subscript_entry(parent : SymbolEntry, subscripts : Array(String))
    if subscripts.size == 1
      parent.subscripts.delete(subscripts[0])
    else
      if entry = parent.subscripts[subscripts[0]]?
        kill_subscript_entry(entry, subscripts[1..])
      end
    end
  end

  # $DATA - check variable status
  def data(name : String, subscripts : Array(String) = [] of String) : UInt8
    if entry = @entries[name]?
      if subscripts.empty?
        result = 0_u8
        result += 1 unless entry.value.empty?
        result += 10 unless entry.subscripts.empty?
        return result
      else
        return data_subscript(entry, subscripts)
      end
    end
    0_u8
  end

  private def data_subscript(parent : SymbolEntry, subscripts : Array(String)) : UInt8
    if subscripts.size == 1
      if entry = parent.subscripts[subscripts[0]]?
        result = 0_u8
        result += 1 unless entry.value.empty?
        result += 10 unless entry.subscripts.empty?
        return result
      end
    else
      if entry = parent.subscripts[subscripts[0]]?
        return data_subscript(entry, subscripts[1..])
      end
    end
    0_u8
  end

  # $ORDER - get next subscript
  def order(name : String, subscripts : Array(String) = [] of String, direction : Int32 = 1) : String?
    if entry = @entries[name]?
      if subscripts.empty?
        return order_children(entry.subscripts, "", direction)
      else
        return order_subscript(entry, subscripts, direction)
      end
    end
    nil
  end

  private def order_subscript(parent : SymbolEntry, subscripts : Array(String), direction : Int32) : String?
    if subscripts.size == 1
      return order_children(parent.subscripts, subscripts[0], direction)
    else
      if entry = parent.subscripts[subscripts[0]]?
        return order_subscript(entry, subscripts[1..], direction)
      end
    end
    nil
  end

  private def order_children(children : Hash(String, SymbolEntry), current : String, direction : Int32) : String?
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
