#!/usr/bin/env ruby

require 'tempfile'

PBL_FILE = "_server.pbl"
PASSPHRASE_FILE = "passphrase.txt"
PASSPHRASE_PLACEHOLDER = "##PASSPHRASE##"
VERSION_REGEXP = /(version=)(\"\d*\.\d*\.)(\d*)(\")/
ADD_ON_MANAGER_PATH = "/usr/share/wesnoth/data/tools/wesnoth_addon_manager"

passphrase = File.readlines(PASSPHRASE_FILE)[0].chomp
tempfile = Tempfile.new(PBL_FILE)
lines = File.readlines(PBL_FILE)
File.open(PBL_FILE, 'w') do |pbl|
  lines.each do |l|
    if l[VERSION_REGEXP]
      new_lower_version = $3.to_i + 1
      new_version = $2 + new_lower_version.to_s + $4
      new_line = $1 + new_version
      puts "Updating version to #{new_version}." 
      pbl.puts new_line
      tempfile.puts new_line
    else
      pbl.puts l
      tempfile.puts l.gsub(PASSPHRASE_PLACEHOLDER, passphrase)
    end
  end
end
tempfile.close

puts "Committing changes to git"
system "git commit #{PBL_FILE} -m \"Automatically created a new version for #{PBL_FILE}\""

puts "Using passphrase #{passphrase}"
puts "Created temporary file #{tempfile.path}"
addon = File.basename(Dir.pwd)
Dir.chdir('..')
puts "Uploading #{addon}"
system "python2 #{ADD_ON_MANAGER_PATH} --pbl=\"#{tempfile.path}\" -u #{addon}"
