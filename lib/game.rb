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
    File.open(file, 'w') do |f|
      f.puts( JSON.pretty_generate(@datas, options = nil) )
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
    @current_round = 1
    @score         = 0
    @stats         = 0
    @stats_scores  = []
    @file_obj      = DataFile.new
    @game_data     = {}
    @state         = {}
  end
  attr_accessor :last_round, :current_round, :score, :file_obj, :game_data, :stats_scores, :state

  def classname
    self.class.to_s.split('::').last.downcase
  end

  def detail
    {}
  end

  def update_award( awards )

    @game_data["award"] ||= {}
    awards.each{|award|
      @game_data["award"][ award ] ||= 0
      @game_data["award"][ award ] += 1
    }
  end

  def update_game_data
    @game_data["date"]   = Date.today.strftime("%Y-%m-%d")
    @game_data["game"]   = self.classname
    @game_data["score"]  = @score
    @game_data["stats"]  = self.calc_stats
    @game_data["detail"] = self.detail
  end

  def pileup_score( round_score )
    @score += round_score
  end

  def incr_round( round )
    @current_round += 1
  end

  def write_data
    @file_obj.write( @file_obj.data_file, @game_data )
  end

  def is_end
    return @current_round > @last_round
  end

  def calc_stats
    @stats_scores.inject(:+) / @last_round .to_f
  end

  def update_state( round )
  end

  def before_input_print
    puts "=========="
    puts "Round%d"%([self.current_round])
  end

  def after_input_print( round_score, awards )
    h = HighLine.new
    display_award = awards.reject{|award| award == 'S-BULL' or award == 'D-BULL' or award == 'TRIPLE' or award == 'DOUBLE'}
    puts h.color("#{display_award.last.to_s}", :yellow ) if display_award
    puts "Score: %d"%([round_score])
    puts h.color("Total: %d"%([self.score]), :green)
  end

  def start
    self.before_input_print
    while points_str = STDIN.gets
      round = Round.const_get( self.classname.capitalize ).new( points_str, @state )

      self.update_award( round.awards )
      self.pileup_score( round.score )
      self.incr_round( round )
      self.stats_scores.push( round.get_stats_score )

      self.update_state( round )
      self.after_input_print( round.score, round.awards )
      break if self.is_end
      self.before_input_print
    end
  end
end

class Countup < Base
  def initialize
    super
    @last_round = 8
  end
end

class Cricketcountup < Base
  def initialize
    super
    @state[:current_round] = @current_round
    @last_round = 8
  end

  def update_state( round )
    @state[:current_round] = @current_round
  end

  def before_input_print
    target = [ 0, 20, 19, 18, 17, 16, 15, 50, 'All Cricket Number' ]
    puts "========== Target is %s!!"%(target[self.current_round])
    puts "Round%d"%([self.current_round])
  end
end

class Roundtheclock < Base
  def initialize
    super
    @state = {:target_number => 1 }
    @last_round = 4
  end

  def detail
    {
      :completed => @state[:completed],
      :target    => @state[:target_number]
    }
  end

  def before_input_print
    puts "========== Target is %s!!"%(@state[:target_number])
    puts "Round%d"%([self.current_round])
  end

  def incr_round( round )
    if round.can_proceed
      @current_round += 1
    end
  end

  def calc_stats
    @stats_scores.inject(:+)
  end

  def is_end
    return @current_round > @last_round || @state[:completed]
  end

  def update_state( round )
    @state = {
      :target_number => round.target_number,
      :completed     => round.completed
    }
  end
end


