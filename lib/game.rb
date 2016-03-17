require 'json'
require 'date'
require 'tapp'
require 'highline'
require './lib/round.rb'


class DataFile
  def initialize
    @data_file = 'data/darts.json'
    @datas     = self.read(@data_file)
  end
  attr_accessor :data_file, :datas

  def write(file,json)
    @datas.push(json)
    open(file, 'w') do |io|
      JSON.dump(@datas, io)
    end
  end

  def read(file)
    return [] if !File.exist?(file)

    json = open(file) do |io|
      JSON.load(io)
    end

    return json
  end
end

class Base
  include Round
  def initialize
    @last_round    = 20
    @current_round = 0
    @score         = 0
    @file_obj      = DataFile.new
    @game_data     = {}
  end
  attr_accessor :last_round, :current_round, :score, :file_obj, :game_data

  def classname
    self.class.to_s.split('::').last.downcase
  end

  def update_award( awards )

    @game_data["award"] ||= {}
    awards.each{|award|
      @game_data["award"][ award ] ||= 0
      @game_data["award"][ award ] += 1
    }
  end

  def update_score( score )
    @game_data["date"]  = Date.today.strftime("%Y-%m-%d")
    @game_data["game"]  = self.classname
    @game_data["score"] = score
  end

  def piliup_score( round_score )
    @score += round_score
  end

  def incr_round
    @current_round += 1
  end

  def write_data
    @file_obj.write( @file_obj.data_file, @game_data )
  end

  def is_last_round
    return @current_round >= @last_round
  end

  def print_score( round_score, awards  )
    h = HighLine.new
    display_award = awards.reject{|award| award == 'S-BULL' or award == 'D-BULL' }
    puts h.color("#{display_award.first.to_s}", :yellow ) if display_award
    puts "Round%d: %d"%([self.current_round,round_score])
    puts h.color("Total: %d"%([self.score]), :green)
  end
end

class Countup < Base
  def initialize
    super
    @last_round = 8
  end

  def start
    while points_str = STDIN.gets
      round = Round.const_get( self.classname.capitalize ).new( points_str, self.current_round )

      self.update_award( round.awards )
      self.piliup_score( round.score )
      self.incr_round

      self.print_score( round.score, round.awards )

      break if self.is_last_round
    end
  end
end
