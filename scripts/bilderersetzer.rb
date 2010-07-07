#!/usr/bin/env ruby

require 'ftools'

def substitute_in_cfgs( dir_name, reg )
  Dir.foreach( dir_name ) do |fname|
    file_name = File.join( dir_name, fname )
    next if ['.', '..'].include? fname
    if File.directory?(file_name) and not fname[/^\./]
      puts "descending to directory #{file_name}"
      substitute_in_cfgs( file_name, reg )
      puts "back from #{file_name}"
    elsif file_name[/\.cfg$/]
      puts "working on file #{file_name}"
      File.copy( file_name, file_name + '~' )
      content = File.read( file_name )
      while (match = content[reg])
        after = "\"units/" + match[1..-1]
        puts "#{match} -> #{after}"
        content.sub!( match, after )
      end
      File.open( file_name, 'w' ) do |f|
        f.puts( content )
      end
    end
  end
end

DIRECTORY = '.'
peoples = %w(lizard_alliance mountain_mages black_army desert_undead swamp_undead wood_pirates artons earthmen)
peoples.each do |people|
  image_file = "\"#{people}/.*\\.png\""
  reg = Regexp.new(image_file)
  after = "\"units/" + image_file[1..-1]
  puts "substitute #{reg} by #{after}"
  substitute_in_cfgs( DIRECTORY, reg )
end
