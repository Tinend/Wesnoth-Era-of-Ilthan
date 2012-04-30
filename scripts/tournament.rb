#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__))
require 'eoi_constants'

class Tournament
  COMMAND = "wesnoth --nogui --multiplayer --era era_of_ilthan --side 1:##SIDE1## --side 2:##SIDE2## --controller 1:ai --controller 2:ai --scenario ##SCENARIO##" 
  WIN_VALUE = 1
  LOSS_VALUE = 0
  DRAW_VALUE = 0.5

  def initialize(factions)
    @points = {}
    @points.default = 0
    @factions = factions
  end

  def find_command( side1, side2, scenario )
    command = COMMAND.dup
    command.gsub!( "##SIDE1##", side1 )
    command.gsub!( "##SIDE2##", side2 )
    command.gsub!( "##SCENARIO##", scenario )
    command
  end

  def fight(scenario)
    @factions.each do |f1|
      @factions.each do |f2|
        command = find_command( f1, f2, scenario )
        puts command
        gamelog = `#{command}`
        if $? != 0
          puts gamelog
        end
        result = gamelog.lines.to_a.last
        if result["1"]
          @points[f1] += WIN_VALUE
          @points[f2] += LOSS_VALUE
          puts "#{f1} defeat #{f2}"
        elsif result["2"]
          @points[f1] += LOSS_VALUE
          @points[f2] += WIN_VALUE
          puts "#{f2} defeat #{f1}"
        else
          @points[f1] += DRAW_VALUE
          @points[f2] += DRAW_VALUE
          puts "#{f1} and #{f2} make a draw."
        end
      end
    end
  end

  def points_of(faction)
    @points[faction]
  end

  def points_string
    maxlen = @factions.map { |f| f.length }.max
    string = "Faction"
    string += " " * ( maxlen - string.length ) + " | Points\n"
    string += @factions.map { |f| f + " " * ( maxlen - f.length ) + " | " + points_of( f ).to_s }.join( "\n" )
    string
  end
end

class Match
  def initialize(scenario)
    @scenario = scenario
  end
end

class Faction
  def initialize
    @matchs = 0
  end
end

SCENARIOS = [
             "multiplayer_The_Freelands"
]

FACTIONS = EOIConstants::PEOPLES.collect { |p| "EOI_" + p }

t = Tournament.new(FACTIONS)
number = ARGV[1].to_i

if ARGV[0] == "all"
  SCENARIOS.each do |s|
    number.times do
      t.fight(s)
      puts
    end
  end
else
  number.times do
    t.fight(SCENARIOS.sample)
    puts
  end
end
puts "Results:"
puts t.points_string
