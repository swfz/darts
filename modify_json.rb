#!/usr/bin/env ruby

require 'json'
require 'tapp'

def read(file)
  return [] if !File.exist?(file)

  json = open(file) do |io|
    JSON.load(io)
  end

  return json
end

file = 'data/darts.json'
data = read(file)
data.each{|r|
  r["stats"] = r["score"] / 8 .to_f if r["game"] == 'countup'
}

puts JSON.pretty_generate(data, options = nil)

outfile = 'data/darts2.json'

File.open(outfile, 'w') do |file|
  file.puts( JSON.pretty_generate(data, options = nil) )
end

