#!/usr/bin/env ruby

require './lib/game.rb'

p 'Prease Gamename in arg' and exit unless ARGV[0]
p 'Error! Not Exist Game' and exit unless Object.const_defined?(ARGV[0].capitalize)

h = HighLine.new
game = Object.const_get(ARGV[0].capitalize).new
game.start
game.update_score( game.score )
game.write_data
puts h.color("Total Score: %d"%(game.score), :red )

