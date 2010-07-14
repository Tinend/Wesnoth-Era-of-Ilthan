require 'ftools'
require 'eoi_constants'

class FileEnumerator
  
  CFG_ENDING = ".cfg"

  PNG_ENDING = ".png"

  SKETCH_ENDINGS = [
                    "_sketch.png",
                    "_skizze.png",
                    "_scetch.png"
                   ]

  def accept_file_name?( file_name )
    raise "Decision on file name not implemented."
  end

  def is_cfg?( file_name )
    file_name.end_with?( CFG_ENDING )
  end

  def is_sketch?( file_name )
    SKETCH_ENDINGS.any? { |e| file_name.end_with?( e ) }
  end

  def is_sprite?( file_name )
    is_png?( file_name ) && !is_sketch?( file_name ) && is_in_sprite_directory?( file_name )
  end

  def is_in_sprite_directory?( file_name )
    EOIConstants::PEOPLES.include?( File.basename( File.dirname( file_name ) ) ) &&
      File.dirname( File.dirname( file_name ) ) == File.join( EOIConstants::BASE_DIR, "images", "units" )
  end

  def is_png?( file_name )
    file_name.end_with?( PNG_ENDING )
  end

  def is_productive?( file_name )
    is_cfg?( file_name ) || is_sprite?( file_name )
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

  def each_line( dir_name, &task )
    each_file( dir_name ) do |file_name|
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
