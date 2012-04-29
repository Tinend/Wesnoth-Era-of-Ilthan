#!/usr/bin/env ruby

require 'tempfile'

PBL_TEMPLATE_FILE = "_server.pbl.template.txt"
PASSPHRASE_FILE = "passphrase.txt"
PASSPHRASE_PLACEHOLDER = "##PASSPHRASE##"
VERSION_REGEXP = /(version=\"\d*\.\d*\.)(\d*)(\")/

passphrase = File.readlines(PASSPHRASE_FILE)[0].chomp
fname = ""
Tempfile.new("_server.pbl") do |pbl|
  fname = pbl.path
  lines File.readlines(PBL_TEMPLATE)
  File.open(PBL_TEMPLATE, 'w') do |template|
    lines.each do |l|
      if l[VERSION_REGEXP]
        new_version = $2.to_i + 1
        new_line = $1 + new_version.to_s + $3
        pbl.puts new_line
        template.puts new_line
      else
        pbl.puts l.gsub(PASSPHRASE_PLACE_HOLDER, passphrase)
        template.puts l
      end
    end
  end
end

puts "Created pbl file #{fname}"
system "git commit #{PBL_TEMPLATE_FILE} -m \"Automatically created a new version for #{PBL_TEMPLATE_FILE}\""
#system("python2 /usr/share/wesnoth/data/tools/")
