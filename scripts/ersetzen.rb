#!/usr/bin/env ruby

$:.unshift( File.dirname( __FILE__ ) )

require 'enumeration_utils'

DIRECTORY = '.'
before = ARGV[0]
after = ARGV[1]

enumerator = new CfgLineEnumerator

enumerator.each_line( DIRECTORY ) do |line|
  line.gsub!( before, after )
end
