require 'date'
require 'tapp'

module Round
  class Base
    def initialize(points_str, current_round)
      @round  = current_round
      @points = []
      @awards = []
      points_str.split(" ").each{|point_str|
        # triple double single bull doublebull
        # 20t    20d    20     50   50d
        point_scale = point_str.split(/([0-9]+)/)
        point = get_point(point_scale);
        @points.push( { "area" => point_scale[1], "scale" => point_scale[2], "point" => point } )
      }
      calc_awards
    end
    attr_accessor :awards
    # points(eg)
    # { area => 20, scale => t,   point => 60 } 20T
    # { area => 50, scale => d,   point => 50 } DBULL
    # { area => 50, scale => nil, point => 50 } SBULL
    # { area => 19, scale => nil, point => 19 } Single 19

    def score
      return @points.map{|r| r["point"]}.inject(:+)
    end
  end

  class Countup < Base
    def initialize(points_str, current_round)
      super
    end

    private
    def calc_awards
      @points.each{|p|
        @awards.push('D-BULL') if p["area"].to_i == 50 and p["scale"] == 'd'
        @awards.push('S-BULL') if p["area"].to_i == 50 and p["scale"].nil?
      }
      # areaが全て同じ、かつ三投ともdoubleかtripleである
      @awards.push('THREEINABED') if @points.map{|r| r["area"] }.uniq.count == 1 and @points.all? {|p| p["scale"] == 't'} or @points.all? {|p| p["scale"] == 'd'}

      @awards.push('TON80') and return @awards    if @points.all? {|p| p["area"].to_i == 20 and p["scale"] == 't'}
      @awards.push('THREEINTHEBLACK') if @points.all? {|p| p["area"].to_i == 50 and p["scale"] == 'd'}
      @awards.push('HATTRICK') and return @awards if @points.all? {|p| p["area"].to_i == 50 }
      @awards.push('HIGHTON') and return @awards  if @points.map{|r| r["point"] }.inject(:+) >= 151
      @awards.push('ROWTON') if @points.map{|r| r["point"] }.inject(:+) >= 101

      return @awards
    end

    def get_point(point_scale)
      point = point_scale[1].to_i
      scale = point_scale[2]
      # singleでもdoubleでもBULLは50
      return 50 if point.to_i == 50;
      return point * 2 if scale == 'd'
      return point * 3 if scale == 't'
      return point
    end
  end

  class Cricketcountup < Base
    def initialize(points_str, current_round)
      super
    end

    private
    def calc_awards
      count = 0

      @points.each{|p|
        @awards.push('D-BULL') if p["area"].to_i == 50 and p["point"] == 50 and p["scale"] == 'd'
        @awards.push('S-BULL') if p["area"].to_i == 50 and p["point"] == 50 and p["scale"].nil?
        if p["point"] > 0
          count += 1 if p["scale"].nil?
          count += 2 if p["scale"] == 'd'
          count += 3 if p["scale"] == 't'
        end
      }

      @awards.push( sprintf("%d-Count", count ) ) if count > 4
      @awards.push('THREEINABED') if @points.map{|r| r["area"] }.uniq.count == 1 and @points.all? {|p| p["scale"] == 't'} or @points.all? {|p| p["scale"] == 'd'}
      @awards.push('WHITEHOURSE') and return @awards if @points.map{|r| r["area"] }.uniq.count == 3 and @points.all? {|p| p["scale"] == 't'} and @points.all? {|p| p["point"] > 0 }

      @awards.push('TON80') and return @awards    if @points.all? {|p| p["area"].to_i == 20 and p["scale"] == 't'}
      @awards.push('THREEINTHEBLACK') if @points.all? {|p| p["area"].to_i == 50 and p["scale"] == 'd'}
      @awards.push('HATTRICK') and return @awards if @points.all? {|p| p["area"].to_i == 50 }
      @awards.push('HIGHTON') and return @awards  if @points.map{|r| r["point"] }.inject(:+) >= 151
      @awards.push('ROWTON') if @points.map{|r| r["point"] }.inject(:+) >= 101

      return @awards
    end

    def get_point(point_scale)
      point = point_scale[1].to_i
      scale = point_scale[2]

      case @round
      when 1 then
        return 0 if point != 20
      when 2 then
        return 0 if point != 19
      when 3 then
        return 0 if point != 18
      when 4 then
        return 0 if point != 17
      when 5 then
        return 0 if point != 16
      when 6 then
        return 0 if point != 15
      when 7 then
        return 0 if point != 50
      when 8 then
        effective = [50, 20, 19, 18, 17, 16, 15]
        return 0 if !effective.include?( point )
      end

      return point * 2 if scale == 'd'
      return point * 3 if scale == 't'
      return point
    end
  end
end


