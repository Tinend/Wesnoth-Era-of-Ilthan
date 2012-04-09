require 'eoi_constants'
require 'fileutils'

class FileEnumerator
  
  include FileUtils::Verbose

  CFG_ENDING = ".cfg"

  PNG_ENDING = ".png"

  SKETCH_ENDINGS = [
                    "_sketch",
                    "_skizze",
                    "_scetch"
                   ]

  OLD_ENDINGS = [
                 "_old",
                 "_alt"
                ]
  
  def is_cfg?( file_name )
    file_name.end_with?( CFG_ENDING )
  end

  def is_sketch?( file_name )
    SKETCH_ENDINGS.any? { |e| file_name.end_with?( e + PNG_ENDING ) }
  end

  def is_sprite?( file_name )
    is_png?( file_name ) && !is_sketch?( file_name ) && is_in_sprite_dir?( file_name ) && !is_old?( file_name )
  end

  def is_old?( file_name )
    OLD_ENDINGS.any? { |e| file_name.end_with?( e + PNG_ENDING ) }
  end

  def is_in_sprite_dir?( file_name )
    EOIConstants::PEOPLES.include?( File.basename( File.dirname( file_name ) ) ) && is_in_image_unit_dir?( File.dirname( file_name ) )
  end

  def is_in_image_unit_dir?( file_name )
    File.basename( File.dirname( file_name ) ) == "units" && is_in_image_dir?( File.dirname( file_name ) )
  end

  def is_in_image_dir?( file_name )
    File.basename( File.dirname( file_name ) ) == "images" && is_in_base_dir?( File.dirname( file_name ) )
  end

  def is_in_base_dir?( file_name )
    File.basename( File.dirname( File.expand_path( file_name ) ) ) == "Era_of_Ilthan"
  end

  def is_png?( file_name )
    file_name.end_with?( PNG_ENDING )
  end

  def is_productive?( file_name )
    is_cfg?( file_name ) || is_sprite?( file_name )
  end

  def accept_file_name?( file_name )
    raise "Decision on file name not implemented."
  end

  def each_file( dir_name, &task )
    Dir.foreach( dir_name ) do |fname|
      file_name = File.join( dir_name, fname )
      next if ['.', '..'].include? fname
      if File.directory?(file_name) and not fname[/^\./]
        puts "descending to directory #{file_name}"
        each_file( file_name, &task )
        puts "back from #{file_name}"
      elsif accept_file_name?( file_name )
        puts "working on file #{file_name}"
        yield file_name
      end
    end
  end
end

class CfgLineEnumerator < FileEnumerator
  def accept_file_name?( file_name )
    return is_cfg?( file_name )
  end

  def each_line( dir_name, &task )
    each_file( dir_name ) do |file_name|
      copy( file_name, file_name + '~' )
      lines = File.readlines( file_name )
      lines.each do |line| 
        yield line, file_name
      end
      File.open( file_name, 'w' ) do |f|
        lines.each do |line|
          f.puts( line )
        end
      end 
    end
  end

  def each( &block )
    each_file( '.' ) do |file_name|
      File.readlines(file_name).each { |line| yield line, file_name }
    end
  end

  include Enumerable

end
