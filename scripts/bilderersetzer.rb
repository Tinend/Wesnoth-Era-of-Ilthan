#!/usr/bin/env ruby

DIRECTORY = '.'

require '~/.wesnoth1.8/data/add-ons/Era_of_Ilthan/scripts/substitute'
peoples = %w(lizard_alliance mountain_mages black_army desert_undead swamp_undead wood_pirates artons earthmen)
peoples.each do |people|
  reg = Regexp.new("\"#{people}/.*\\.png\"")
  after = "units/" + people
  puts "substitute #{reg} by #{after}"
  substitute_in_cfgs( DIRECTORY, reg, after )
end
