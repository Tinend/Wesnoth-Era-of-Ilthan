#!/usr/bin/env ruby

$:.unshift( File.dirname( __FILE__ ) )

require 'enumeration_utils'

DOWNLOAD_FILE = File.join( "Era_of_Ilthan", "downloads", "Era_of_Ilthan.tar" )
TAR_COMMAND = "tar -cf " + DOWNLOAD_FILE + " "
COMPRESS_COMMAND = "gzip " + DOWNLOAD_FILE
RM_COMMAND = "rm " + DOWNLOAD_FILE + " " + DOWNLOAD_FILE + ".gz"

Dir.chdir( File.join( File.dirname( __FILE__ ), "..", ".." ) )

class DownloadCollector < FileEnumerator
  def accept_file_name?( file_name )
    is_productive?( file_name )
  end
end

dc = DownloadCollector.new

file_list = []
dc.each_file( "Era_of_Ilthan" ) { |f| file_list.push( f ) }
system( RM_COMMAND )
system( TAR_COMMAND + file_list.join( " " ) )
system( COMPRESS_COMMAND )
