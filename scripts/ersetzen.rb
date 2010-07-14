#!/usr/bin/env ruby

require '~/.wesnoth1.8/data/add-ons/Era_of_Ilthan/scripts/enumeration_utils'

DIRECTORY = '.'
before = ARGV[0]
after = ARGV[1]

enumerator = new CfgLineEnumerator

enumerator.each_line( DIRECTORY ) do |line|
  line.gsub!( before, after )
end
