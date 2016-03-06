#!/usr/bin/env ruby

require 'json'
require 'date'
require 'tapp'

# datafile format
# score
# {
#   2016-03-01 => [ 500, 400, 450... ],
#   2016-03-02 => [ 500, 400, 450... ]
# }
# award
# {
#   2016-03-01 => { ROWTON => 3, HIGHTON => 2, ...},
#   2016-03-02 => { ROWTON => 3, HIGHTON => 2, ...}
# }

class DataFile
  def initialize(classname)
    @game_file  = classname + '.json'
    @award_file = 'award.json'
  end
  attr_accessor :game_file, :award_file

  def write(file,json)
    open(file, 'w') do |io|
      JSON.dump(json, io)
    end
  end

  def read(file)
    return {} if !File.exist?(file)

    json = open(file) do |io|
      JSON.load(io)
    end

    return json
  end
end

class Game
  def initialize
    @last_round    = 20
    @current_round = 0
    @score         = 0
    @datafile      = DataFile.new(self.classname)
    @award_data    = {}
    @game_data     = {}
    @today         = Date.today.strftime("%Y-%m-%d")
  end
  attr_accessor :last_round, :current_round, :score, :datafile, :award_data, :game_data

  def classname
    self.class.to_s.split('::').last.downcase
  end

  def update_award( awards )
    @award_data[ @today ] ||= {}

    awards.each{|award|
      @award_data[ @today ][ award ] ||= 0
      @award_data[ @today ][ award ] += 1
    }
  end

  def update_score( score )
    @game_data[ @today ] ||= []
    @game_data[ @today ].push( score )
  end

  def read_data
    @game_data  = @datafile.read( @datafile.game_file )
    @award_data = @datafile.read( @datafile.award_file )
  end

  def write_data
    @game_data.tapp
    @award_data.tapp
    @datafile.write( @datafile.game_file, @game_data )
    @datafile.write( @datafile.award_file, @award_data )
  end
end

class Round
  def initialize(points_str)
    @points = []
    @awards = []
    @score  = 0
    points_str.split(" ").each{|point_str|
      # triple double single bull doublebull
      # 20t    20d    20     50   50d
      point_scale = point_str.split(/([0-9]+)/)
      point = get_point(point_scale);
      @points.push( { "area" => point_scale[1], "scale" => point_scale[2], "point" => point } )
    }
  end
  # points(eg)
  # { area => 20, scale => t,   point => 60 } 20T
  # { area => 50, scale => d,   point => 50 } DBULL
  # { area => 50, scale => nil, point => 50 } SBULL
  # { area => 19, scale => nil, point => 19 } Single 19

  def get_awards
    @points.each{|p|
      @awards.push('D-BULL') if p["area"].to_i == 50 and p["scale"] == 'd'
      @awards.push('S-BULL') if p["area"].to_i == 50 and p["scale"].nil?
    }
    # areaが全て同じ、かつ三投ともdoubleかtripleである
    @awards.push('THREEINABED')     if @points.map{|r| r["area"] }.uniq.count == 1 and @points.all? {|p| p["scale"] == 't'} or @points.all? {|p| p["scale"] == 'd'}

    @awards.push('TON80') and return @awards    if @points.all? {|p| p["area"].to_i == 20 and p["scale"] == 't'}
    @awards.push('THREEINTHEBLACK') if @points.all? {|p| p["area"].to_i == 50 and p["scale"] == 'd'}
    @awards.push('HATTRICK') and return @awards if @points.all? {|p| p["area"].to_i == 50 }
    @awards.push('HIGHTON') and return @awards  if @points.map{|r| r["point"] }.inject(:+) >= 151
    @awards.push('ROWTON') if @points.map{|r| r["point"] }.inject(:+) >= 101

    @awards.tapp
    return @awards
  end

  def round_score
    return @points.map{|r| r["point"]}.inject(:+)
  end

  private
  def get_point(point_scale)
    # singleでもdoubleでもBULLは50
    return 50 if point_scale[1].to_i == 50;
    return point_scale[1].to_i * 2 if point_scale[2] == 'd'
    return point_scale[1].to_i * 3 if point_scale[2] == 't'
    return point_scale[1].to_i
  end
end

class Countup < Game
  def initialize
    super
    @last_round = 2
  end

  def start
    while points_str = STDIN.gets
      round = Round.new( points_str )

      awards = round.get_awards
      display_award = awards.reject{|award| award == 'S-BULL' or award == 'D-BULL' }

      puts "Round%d: %d"%([self.current_round+1,round.round_score])
      puts display_award if display_award

      self.update_award( awards )
      self.score += round.round_score
      self.current_round += 1
      break if self.current_round >= self.last_round
    end
  end
end

game = Countup.new
game.read_data
game.start
game.update_score( game.score )
game.write_data
puts "Total Score: %d"%(game.score)
