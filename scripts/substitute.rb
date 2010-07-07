require 'ftools'

def substitute_in_cfgs( dir_name, before, after )
  Dir.foreach( dir_name ) do |fname|
    file_name = File.join( dir_name, fname )
    next if ['.', '..'].include? fname
    if File.directory?(file_name) and not fname[/^\./]
      puts "descending to directory #{file_name}"
      substitute_in_cfgs( file_name, before, after )
      puts "back from #{file_name}"
    elsif file_name[/\.cfg$/]
      puts "working on file #{file_name}"
      File.copy( file_name, file_name + '~' )
      content = File.read( file_name )
      content.gsub!( before, after )
      File.open( file_name, 'w' ) do |f|
        f.puts( content )
      end
    end
  end
end
