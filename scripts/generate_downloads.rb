#!/usr/bin/env ruby

$:.unshift( File.dirname( __FILE__ ) )

require 'enumeration_utils'

Dir.chdir( File.join( File.dirname( __FILE__ ), "..", ".." ) )

VERSION_FILE = File.join( "Era_of_Ilthan", "downloads", "version" )
version = 1 + File.read( VERSION_FILE ).to_i
File.open( VERSION_FILE, 'w' ) { |f| f.puts version }
DOWNLOAD_FILE = File.join( "Era_of_Ilthan", "downloads", "Era_of_Ilthan-0.0.#{version}.tar" )
TAR_COMMAND = "tar -cf " + DOWNLOAD_FILE + " "
COMPRESS_COMMAND = "gzip " + DOWNLOAD_FILE

class DownloadCollector < FileEnumerator
  def accept_file_name?( file_name )
    is_productive?( file_name )
  end
end

dc = DownloadCollector.new

file_list = []
dc.each_file( "Era_of_Ilthan" ) { |f| file_list.push( f ) }
system( TAR_COMMAND + file_list.join( " " ) )
system( COMPRESS_COMMAND )
