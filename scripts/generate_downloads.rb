#!/usr/bin/env ruby

$:.unshift( File.dirname( __FILE__ ) )

require 'enumeration_utils'

TAR_COMMAND = "tar -cf ##DOWNLOAD_FILE## ##FILE_LIST##"
COMPRESS_COMMAND = "gzip ##DOWNLOAD_FILE##"
DOWNLOAD_FILE = File.join( "downloads", "Era_of_Ilthan.tar" )

Dir.chdir( File.join( File.dirname( __FILE__ ), ".." ) )

class DownloadCollector < FileEnumerator
  def acceptable_file_name?( file_name )
    is_productive?( file_name )
  end
end

dc = DownloadCollector.new

file_list = []
dc.each_file( '.' ) { |f| file_list.push( f ) }
tar_command = TAR_COMMAND.clone
tar_command.gsub!( "##DOWNLOAD_FILE##", DOWNLOAD_FILE )
tar_command.gsub!( "##FILE_LIST##", file_list.join( " " ) )
system( tar_command )
compress_command = COMPRESS_COMMAND.clone
compress_command.gsub!( "##DOWNLOAD_FILE##", DOWNLOAD_FILE )
system( compress_command )
