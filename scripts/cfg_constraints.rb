#!/usr/bin/env ruby

$:.unshift( File.dirname( __FILE__ ) )

require 'constraints'

class IdConstraint < IntegrityConstraint
  def relevant_part( line )
    return nil unless line[/^\s*id\s*=\s*\w*\s*$/]
    line.sub( /^\s*id\s*=\s*/, "" ).gsub(/\s*$/, "")
  end
end

check = IdConstraint.new

all_success = check.all? do |id, file_name|
  if id + ".cfg" == "EOI_" + file_name
    true
  else
    puts id + ".cfg", "EOI_" + file_name
    false
  end
end

if all_success
  puts "Id Filename successfull"
end
