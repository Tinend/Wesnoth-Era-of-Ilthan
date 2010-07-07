#!/usr/bin/env ruby

require '~/.wesnoth1.8/data/add-ons/Era_of_Ilthan/scripts/substitute'

DIRECTORY = '.'
before = ARGV[0]
after = ARGV[1]

substitute_in_cfgs( DIRECTORY, before, after )
