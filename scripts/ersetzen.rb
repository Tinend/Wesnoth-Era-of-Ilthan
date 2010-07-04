#!/usr/bin/env ruby

require 'ftools'
DIRECTORY = '.'

def substitude_in_cfgs( before, after )
  Dir.foreach( DIRECTORY ) do |fname|
    file_name = File.join( DIRECTORY, fname )
    next if ['.', '..'].include? fname or not fname[/\.cfg$/]
    File.copy( file_name, file_name + '~' )
    content = File.read( file_name )
    content.gsub!( before, after )
    File.open( file_name, 'w' ) do |f|
      f.puts( content )
    end
  end
end

before = ARGV[0]
after = ARGV[1]

substitude_in_cfgs( before, after ) if STDIN.gets.chomp == "y"
