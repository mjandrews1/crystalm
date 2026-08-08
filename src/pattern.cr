# Package: crystalm
# File:    src/pattern.cr
# Summary: MUMPS Pattern Matching
#
# SPDX-FileCopyrightText:  2026 Mark J. Andrews
# SPDX-License-Identifier: AGPL-3.0-or-later

# Pattern matching
module PatternMatcher
  # Match a string against a pattern
  def self.match(str : String, pattern : String) : Bool
    match_pattern(str, 0, pattern, 0)
  end

  private def self.match_pattern(str : String, si : Int32, pattern : String, pi : Int32) : Bool
    # Base cases
    if pi >= pattern.size
      return si >= str.size
    end

    if si >= str.size
      # Check if remaining pattern is optional
      while pi < pattern.size
        if pattern[pi] == '.' || pattern[pi] == '*'
          pi += 1
        else
          return false
        end
      end
      return true
    end

    # Get count
    min_count = 0
    max_count = Int32::MAX
    new_pi = pi

    if pattern[new_pi].number?
      min_count = pattern[new_pi].to_i
      max_count = min_count
      new_pi += 1
    end

    if new_pi < pattern.size && pattern[new_pi] == '.'
      new_pi += 1
      max_count = Int32::MAX
    end

    if new_pi < pattern.size && pattern[new_pi].number?
      max_count = pattern[new_pi].to_i
      new_pi += 1
    end

    # Get pattern code
    return false if new_pi >= pattern.size
    code = pattern[new_pi]
    new_pi += 1

    # Match characters
    matched = 0
    si2 = si
    while si2 < str.size && matched < max_count
      if matches_code(str[si2], code)
        si2 += 1
        matched += 1
      else
        break
      end
    end

    return false if matched < min_count

    # Try to match remaining
    match_pattern(str, si2, pattern, new_pi)
  end

  private def self.matches_code(c : Char, code : Char) : Bool
    case code
    when 'A', 'a'
      c.letter?
    when 'N', 'n'
      c.number?
    when 'E', 'e'
      true
    when 'U', 'u'
      c.uppercase?
    when 'L', 'l'
      c.lowercase?
    when 'P', 'p'
      c.punctuation?
    when 'C', 'c'
      !c.ascii? || c.ord < 32
    else
      false
    end
  end
end
