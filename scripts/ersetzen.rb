#!/usr/bin/env ruby

$:.unshift( File.dirname( __FILE__ ) )

require 'enumeration_utils'

DIRECTORY = '.'
before = ARGV[0]
after = ARGV[1]

enumerator = CfgLineEnumerator.new

enumerator.each_line( DIRECTORY ) do |line, file_name|
  line.gsub!( before, after )
end
