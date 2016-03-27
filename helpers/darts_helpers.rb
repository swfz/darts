require 'bigdecimal/util'
require 'bigdecimal'

module ZerooneRating
  def get_zeroone_rating(stats)
    if stats < 40
      rating = 1
    elsif stats < 95
      rating = ( stats - 30 ) / 5
    else
      rating = ( stats - 4 ) / 7
    end

    return rating
  end
end
module CricketRating
  def get_cricket_rating(stats)
    if stats < 1.3
      rating = 1
    elsif stats < 3.5
      rating = ( stats - 0.9 ) / 0.2
    else
      rating = ( stats - 0.25 ) / 0.25
    end

    return rating
  end
end
module FormatFloat
  def to_f2(n)
    n.to_s.to_d.floor(2).to_f
  end
end
module Stats
  def get_stats(rows)
    rows.inject(0){|sum,r| n = r.stats||0; sum + n} / rows.length
  end
end

module Flight
  def get_flight(rating)
    case rating
    when 1..3.99
      "C"
    when 4..5.99
      "CC"
    when 6..7.99
      "B"
    when 8..9.99
      "BB"
    when 10..12.99
      "A"
    end
  end
end
