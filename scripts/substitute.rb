require 'ftools'

class FileEnumerator
  def accept_file_name?( file_name )
    raise "Decision on file name not implemented."
  end

  def each_file( dir_name, &task )
    Dir.foreach( dir_name ) do |fname|
      file_name = File.join( dir_name, fname )
      next if ['.', '..'].include? fname
      if File.directory?(file_name) and not fname[/^\./]
        puts "descending to directory #{file_name}"
        substitute_in_cfgs( file_name, before, after )
        puts "back from #{file_name}"
      elsif acceptable_file_name?( file_name )
        puts "working on file #{file_name}"
        yield file_name
      end
    end
  end
end

class CfgLineEnumerator < FileEnumerator
  def accept_file_name?( file_name )
    return file_name.match( /\.cfg$/ )
  end

  def each_line( &task )
    each_file do |file_name|
      File.copy( file_name, file_name + '~' )
      lines = File.readlines( file_name )
      lines.each do |line| 
        yield line
      end
      File.open( file_name, 'w' ) do |f|
        lines.each do |line|
          f.puts( line )
        end
      end 
    end
  end
end
