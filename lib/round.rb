require 'date'
require 'tapp'

class Round
  def initialize(points_str, current_round)
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
    @awards.push('THREEINABED') if @points.map{|r| r["area"] }.uniq.count == 1 and @points.all? {|p| p["scale"] == 't'} or @points.all? {|p| p["scale"] == 'd'}

    @awards.push('TON80') and return @awards    if @points.all? {|p| p["area"].to_i == 20 and p["scale"] == 't'}
    @awards.push('THREEINTHEBLACK') if @points.all? {|p| p["area"].to_i == 50 and p["scale"] == 'd'}
    @awards.push('HATTRICK') and return @awards if @points.all? {|p| p["area"].to_i == 50 }
    @awards.push('HIGHTON') and return @awards  if @points.map{|r| r["point"] }.inject(:+) >= 151
    @awards.push('ROWTON') if @points.map{|r| r["point"] }.inject(:+) >= 101

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



