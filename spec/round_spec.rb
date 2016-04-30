require './lib/round.rb'

shared_examples 'check round' do |exp|
  it 'score' do
    expect( round.score ).to eq(exp[:score])
  end
  it 'awards' do
    expect( round.awards ).to match_array(exp[:awards])
  end
  it 'stats' do
    expect( round.get_stats_score ).to eq(exp[:stats])
  end
end

describe Round::Countup do
  context 'standard 1 args in triple' do
    let(:round) { Round::Countup.new( '10t', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 30,
      :stats => 30,
      :awards => []
    }
  end
  context 'standard 1 args in double' do
    let(:round) { Round::Countup.new( '10d', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 20,
      :stats => 20,
      :awards => []
    }
  end
  context 'standard 3 args' do
    let(:round) { Round::Countup.new( '10 10 10', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 30,
      :stats => 30,
      :awards => []
    }
  end
  context 'standard 2 args' do
    let(:round) { Round::Countup.new( '10 10', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 20,
      :stats => 20,
      :awards => []
    }
  end
  context 'standard 1 args' do
    let(:round) { Round::Countup.new( '10', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 10,
      :stats => 10,
      :awards => []
    }
  end
  context 'award S-BULL' do
    let(:round) { Round::Countup.new( '1 50 1', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 52,
      :stats => 52,
      :awards => [ 'S-BULL' ]
    }
  end
  context 'award D-BULL' do
    let(:round) { Round::Countup.new( '1 50d 1', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 52,
      :stats => 52,
      :awards => [ 'D-BULL' ]
    }
  end
  context 'award ROWTON' do
    let(:round) { Round::Countup.new( '1 50d 50', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 101,
      :stats => 101,
      :awards => [ 'D-BULL','S-BULL','ROWTON' ]
    }
  end
  context 'score is 100 not ROWTON' do
    let(:round) { Round::Countup.new( '50d 50', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 100,
      :stats => 100,
      :awards => [ 'D-BULL','S-BULL' ]
    }
  end
  context 'award HATTRICK' do
    let(:round) { Round::Countup.new( '50 50 50d', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 150,
      :stats => 150,
      :awards => [ 'D-BULL','S-BULL','S-BULL','HATTRICK' ]
    }
  end
  context 'award THREEINTHEBLACK' do
    let(:round) { Round::Countup.new( '50d 50d 50d', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 150,
      :stats => 150,
      :awards => [ 'D-BULL','D-BULL','D-BULL','THREEINTHEBLACK' ]
    }
  end
  context 'award HIGHTON' do
    let(:round) { Round::Countup.new( '50 50d 19t', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 157,
      :stats => 157,
      :awards => [ 'D-BULL','S-BULL','HIGHTON' ]
    }
  end
  context 'score is 150 not HIGHTON' do
    let(:round) { Round::Countup.new( '20t 20t 10t', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 150,
      :stats => 150,
      :awards => [ 'ROWTON' ]
    }
  end
  context 'award TON80' do
    let(:round) { Round::Countup.new( '20t 20t 20t', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 180,
      :stats => 180,
      :awards => [ 'TON80', 'THREEINABED' ]
    }
  end
  context 'award THREEINABED in double' do
    let(:round) { Round::Countup.new( '10d 10d 10d', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 60,
      :stats => 60,
      :awards => [ 'THREEINABED' ]
    }
  end
  context 'award THREEINABED in triple' do
    let(:round) { Round::Countup.new( '10t 10t 10t', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 90,
      :stats => 90,
      :awards => [ 'THREEINABED' ]
    }
  end
  context 'award THREEINABED in triple over HIGHTON' do
    let(:round) { Round::Countup.new( '19t 19t 19t', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 171,
      :stats => 171,
      :awards => [ 'THREEINABED', 'HIGHTON' ]
    }
  end
  context 'award THREEINABED in triple over ROWTON' do
    let(:round) { Round::Countup.new( '15t 15t 15t', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 135,
      :stats => 135,
      :awards => [ 'THREEINABED', 'ROWTON' ]
    }
  end
  context 'award THREEINABED in double over ROWTON' do
    let(:round) { Round::Countup.new( '20d 20d 20d', {:current_round => 1 } ) }
    include_examples 'check round', {
      :score => 120,
      :stats => 120,
      :awards => [ 'THREEINABED', 'ROWTON' ]
    }
  end
end

describe Round::Cricketcountup do
  describe 'args check' do
    context 'standard 1 args is point' do
      let(:round) { Round::Cricketcountup.new( '20', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 20,
        :stats => 1,
        :awards => []
      }
    end
    context 'standard 2 args is point' do
      let(:round) { Round::Cricketcountup.new( '20 20', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 40,
        :stats => 2,
        :awards => []
      }
    end
    context 'standard 3 args is point' do
      let(:round) { Round::Cricketcountup.new( '20 20 20', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 60,
        :stats => 3,
        :awards => []
      }
    end
    context 'standard 3 args is not point' do
      let(:round) { Round::Cricketcountup.new( '19 10 1', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 0,
        :stats => 0,
        :awards => []
      }
    end
    context 'standard 3 args complex' do
      let(:round) { Round::Cricketcountup.new( '19 20 1', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 20,
        :stats => 1,
        :awards => []
      }
    end
  end

  describe 'round1 target is 20' do
    context 'none award' do
      let(:round) { Round::Cricketcountup.new( '20 20 20', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 60,
        :stats => 3,
        :awards => []
      }
    end
    context 'award DOUBLE' do
      let(:round) { Round::Cricketcountup.new( '20d 1 1', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 40,
        :stats => 2,
        :awards => [ 'DOUBLE' ]
      }
    end
    context 'award TRIPLE' do
      let(:round) { Round::Cricketcountup.new( '1 20t 1', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 60,
        :stats => 3,
        :awards => [ 'TRIPLE' ]
      }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '20 20t 20', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 100,
        :stats => 5,
        :awards => [ '5-Count', 'TRIPLE' ]
      }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '20t 20t 19', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 120,
        :stats => 6,
        :awards => [ '6-Count', 'TRIPLE', 'TRIPLE' ]
      }
    end
    context 'award THREEINABED 6-Count' do
      let(:round) { Round::Cricketcountup.new( '20d 20d 20d', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 120,
        :stats => 6,
        :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '20t 20t 20', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 140,
        :stats => 7,
        :awards => [ '7-Count', 'TRIPLE', 'TRIPLE' ]
      }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '20t 20t 20d', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 160,
        :stats => 8,
        :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award TON80 THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '20t 20t 20t', {:current_round => 1 } ) }
      include_examples 'check round', {
        :score => 180,
        :stats => 9,
        :awards => [ 'TON80', 'THREEINABED', '9-Count', 'TRIPLE', 'TRIPLE', 'TRIPLE' ]
      }
    end
  end
  describe 'round2 target is 19' do
    context 'none award' do
      let(:round) { Round::Cricketcountup.new( '19 19 19', {:current_round => 2 } ) }
      include_examples 'check round', {
        :score => 57,
        :stats => 3,
        :awards => []
      }
    end
    context 'award DOUBLE' do
      let(:round) { Round::Cricketcountup.new( '19d 1 1', {:current_round => 2 } ) }
      include_examples 'check round', {
        :score => 38,
        :stats => 2,
        :awards => [ 'DOUBLE' ]
      }
    end
    context 'award TRIPLE' do
      let(:round) { Round::Cricketcountup.new( '19t 1 1', {:current_round => 2 } ) }
      include_examples 'check round', {
        :score => 57,
        :stats => 3,
        :awards => [ 'TRIPLE' ]
      }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '19t 19d 1', {:current_round => 2 } ) }
      include_examples 'check round', {
        :score => 95,
        :stats => 5,
        :awards => [ '5-Count', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '19t 19d 19', {:current_round => 2 } ) }
      include_examples 'check round', {
        :score => 114,
        :stats => 6,
        :awards => [ '6-Count', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award THREEINABED 6-Count' do
      let(:round) { Round::Cricketcountup.new( '19d 19d 19d', {:current_round => 2 } ) }
      include_examples 'check round', {
        :score => 114,
        :stats => 6,
        :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '19t 19d 19d', {:current_round => 2 } ) }
      include_examples 'check round', {
        :score => 133,
        :stats => 7,
        :awards => [ '7-Count', 'TRIPLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '19t 19t 19d', {:current_round => 2 } ) }
      include_examples 'check round', {
        :score => 152,
        :stats => 8,
        :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '19t 19t 19t', {:current_round => 2 } ) }
      include_examples 'check round', {
        :score => 171,
        :stats => 9,
        :awards => [ '9-Count', 'THREEINABED', 'TRIPLE', 'TRIPLE', 'TRIPLE' ]
      }
    end
  end
  describe 'round3 target is 18' do
    context 'none award' do
      let(:round) { Round::Cricketcountup.new( '18 18 18', {:current_round => 3 } ) }
      include_examples 'check round', {
        :score => 54,
        :stats => 3,
        :awards => []
      }
    end
    context 'award DOUBLE' do
      let(:round) { Round::Cricketcountup.new( '18d 1 1', {:current_round => 3 } ) }
      include_examples 'check round', {
        :score => 36,
        :stats => 2,
        :awards => [ 'DOUBLE' ]
      }
    end
    context 'award TRIPLE' do
      let(:round) { Round::Cricketcountup.new( '18t 1 1', {:current_round => 3 } ) }
      include_examples 'check round', {
        :score => 54,
        :stats => 3,
        :awards => [ 'TRIPLE' ]
      }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 18d 1', {:current_round => 3 } ) }
      include_examples 'check round', {
        :score => 90,
        :stats => 5,
        :awards => [ '5-Count', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 18d 18', {:current_round => 3 } ) }
      include_examples 'check round', {
        :score => 108,
        :stats => 6,
        :awards => [ '6-Count', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award THREEINABED 6-Count' do
      let(:round) { Round::Cricketcountup.new( '18d 18d 18d', {:current_round => 3 } ) }
      include_examples 'check round', {
        :score => 108,
        :stats => 6,
        :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 18d 18d', {:current_round => 3 } ) }
      include_examples 'check round', {
        :score => 126,
        :stats => 7,
        :awards => [ '7-Count', 'TRIPLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 18t 18d', {:current_round => 3 } ) }
      include_examples 'check round', {
        :score => 144,
        :stats => 8,
        :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 18t 18t', {:current_round => 3 } ) }
      include_examples 'check round', {
        :score => 162,
        :stats => 9,
        :awards => [ '9-Count', 'THREEINABED', 'TRIPLE', 'TRIPLE', 'TRIPLE' ]
      }
    end
  end
  describe 'round4 target is 17' do
    context 'none award' do
      let(:round) { Round::Cricketcountup.new( '17 17 17', {:current_round => 4 } ) }
      include_examples 'check round', {
        :score => 51,
        :stats => 3,
        :awards => []
      }
    end
    context 'award DOUBLE' do
      let(:round) { Round::Cricketcountup.new( '17d 1 1', {:current_round => 4 } ) }
      include_examples 'check round', {
        :score => 34,
        :stats => 2,
        :awards => [ 'DOUBLE' ]
      }
    end
    context 'award TRIPLE' do
      let(:round) { Round::Cricketcountup.new( '17t 1 1', {:current_round => 4 } ) }
      include_examples 'check round', {
        :score => 51,
        :stats => 3,
        :awards => [ 'TRIPLE' ]
      }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '17t 17d 1', {:current_round => 4 } ) }
      include_examples 'check round', {
        :score => 85,
        :stats => 5,
        :awards => [ '5-Count', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '17t 17d 17', {:current_round => 4 } ) }
      include_examples 'check round', {
        :score => 102,
        :stats => 6,
        :awards => [ '6-Count', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award THREEINABED 6-Count' do
      let(:round) { Round::Cricketcountup.new( '17d 17d 17d', {:current_round => 4 } ) }
      include_examples 'check round', {
        :score => 102,
        :stats => 6,
        :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '17t 17d 17d', {:current_round => 4 } ) }
      include_examples 'check round', {
        :score => 119,
        :stats => 7,
        :awards => [ '7-Count', 'TRIPLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '17t 17t 17d', {:current_round => 4 } ) }
      include_examples 'check round', {
        :score => 136,
        :stats => 8,
        :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '17t 17t 17t', {:current_round => 4 } ) }
      include_examples 'check round', {
        :score => 153,
        :stats => 9,
        :awards => [ '9-Count', 'THREEINABED', 'TRIPLE', 'TRIPLE', 'TRIPLE' ]
      }
    end
  end
  describe 'round5 target is 16' do
    context 'none award' do
      let(:round) { Round::Cricketcountup.new( '16 16 16', {:current_round => 5 } ) }
      include_examples 'check round', {
        :score => 48,
        :stats => 3,
        :awards => []
      }
    end
    context 'award DOUBLE' do
      let(:round) { Round::Cricketcountup.new( '16d 1 1', {:current_round => 5 } ) }
      include_examples 'check round', {
        :score => 32,
        :stats => 2,
        :awards => [ 'DOUBLE' ]
      }
    end
    context 'award TRIPLE' do
      let(:round) { Round::Cricketcountup.new( '16t 1 1', {:current_round => 5 } ) }
      include_examples 'check round', {
        :score => 48,
        :stats => 3,
        :awards => [ 'TRIPLE' ]
      }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '16t 16d 1', {:current_round => 5 } ) }
      include_examples 'check round', {
        :score => 80,
        :stats => 5,
        :awards => [ '5-Count', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '16t 16d 16', {:current_round => 5 } ) }
      include_examples 'check round', {
        :score => 96,
        :stats => 6,
        :awards => [ '6-Count', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award THREEINABED 6-Count' do
      let(:round) { Round::Cricketcountup.new( '16d 16d 16d', {:current_round => 5 } ) }
      include_examples 'check round', {
        :score => 96,
        :stats => 6,
        :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '16t 16d 16d', {:current_round => 5 } ) }
      include_examples 'check round', {
        :score => 112,
        :stats => 7,
        :awards => [ '7-Count', 'TRIPLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '16t 16t 16d', {:current_round => 5 } ) }
      include_examples 'check round', {
        :score => 128,
        :stats => 8,
        :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '16t 16t 16t', {:current_round => 5 } ) }
      include_examples 'check round', {
        :score => 144,
        :stats => 9,
        :awards => [ '9-Count', 'THREEINABED', 'TRIPLE', 'TRIPLE', 'TRIPLE' ]
      }
    end
  end
  describe 'round6 target is 15' do
    context 'none award' do
      let(:round) { Round::Cricketcountup.new( '15 15 15', {:current_round => 6 } ) }
      include_examples 'check round', {
        :score => 45,
        :stats => 3,
        :awards => []
      }
    end
    context 'award DOUBLE' do
      let(:round) { Round::Cricketcountup.new( '15d 1 1', {:current_round => 6 } ) }
      include_examples 'check round', {
        :score => 30,
        :stats => 2,
        :awards => [ 'DOUBLE' ]
      }
    end
    context 'award TRIPLE' do
      let(:round) { Round::Cricketcountup.new( '15t 1 1', {:current_round => 6 } ) }
      include_examples 'check round', {
        :score => 45,
        :stats => 3,
        :awards => [ 'TRIPLE' ]
      }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '15t 15d 1', {:current_round => 6 } ) }
      include_examples 'check round', {
        :score => 75,
        :stats => 5,
        :awards => [ '5-Count', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '15t 15d 15', {:current_round => 6 } ) }
      include_examples 'check round', {
        :score => 90,
        :stats => 6,
        :awards => [ '6-Count', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award THREEINABED 6-Count' do
      let(:round) { Round::Cricketcountup.new( '15d 15d 15d', {:current_round => 6 } ) }
      include_examples 'check round', {
        :score => 90,
        :stats => 6,
        :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '15t 15d 15d', {:current_round => 6 } ) }
      include_examples 'check round', {
        :score => 105,
        :stats => 7,
        :awards => [ '7-Count', 'TRIPLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '15t 15t 15d', {:current_round => 6 } ) }
      include_examples 'check round', {
        :score => 120,
        :stats => 8,
        :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '15t 15t 15t', {:current_round => 6 } ) }
      include_examples 'check round', {
        :score => 135,
        :stats => 9,
        :awards => [ '9-Count', 'THREEINABED', 'TRIPLE', 'TRIPLE', 'TRIPLE' ]
      }
    end
  end
  describe 'round7 target is BULL' do
    context 'none point' do
      let(:round) { Round::Cricketcountup.new( '15 16 17', {:current_round => 7 } ) }
      include_examples 'check round', {
        :score => 0,
        :stats => 0,
        :awards => []
      }
    end
    context 'none point2' do
      let(:round) { Round::Cricketcountup.new( '18 19 20', {:current_round => 7 } ) }
      include_examples 'check round', {
        :score => 0,
        :stats => 0,
        :awards => []
      }
    end
    context 'award S-BULL' do
      let(:round) { Round::Cricketcountup.new( '50 1 1', {:current_round => 7 } ) }
      include_examples 'check round', {
        :score => 25,
        :stats => 1,
        :awards => [ 'S-BULL' ]
      }
    end
    context 'award D-BULL' do
      let(:round) { Round::Cricketcountup.new( '50d 1 1', {:current_round => 7 } ) }
      include_examples 'check round', {
        :score => 50,
        :stats => 2,
        :awards => [ 'D-BULL', 'DOUBLE' ]
      }
    end
    context 'award HATTRICK' do
      let(:round) { Round::Cricketcountup.new( '50 50 50', {:current_round => 7 } ) }
      include_examples 'check round', {
        :score => 75,
        :stats => 3,
        :awards => [ 'HATTRICK', 'S-BULL', 'S-BULL', 'S-BULL' ]
      }
    end
    context 'award 5-Count HATTRICK' do
      let(:round) { Round::Cricketcountup.new( '50d 50d 50', {:current_round => 7 } ) }
      include_examples 'check round', {
        :score => 125,
        :stats => 5,
        :awards => [
          '5-Count', 'HATTRICK',
          'D-BULL', 'D-BULL', 'S-BULL', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award THREEINTHEBLACK 6-Count' do
      let(:round) { Round::Cricketcountup.new( '50d 50d 50d', {:current_round => 7 } ) }
      include_examples 'check round', {
        :score => 150,
        :stats => 6,
        :awards => [
          '6-Count', 'THREEINTHEBLACK', 'THREEINABED', 'HATTRICK',
          'D-BULL', 'D-BULL', 'D-BULL', 'DOUBLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
  end
  describe 'round8 target is ALL CRICKET Number' do
    context 'none point' do
      let(:round) { Round::Cricketcountup.new( '14 1 10', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 0,
        :stats => 0,
        :awards => []
      }
    end
    context 'standard point 15 16 17' do
      let(:round) { Round::Cricketcountup.new( '15 16 17', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 48,
        :stats => 3,
        :awards => []
      }
    end
    context 'standard point 18 19 20' do
      let(:round) { Round::Cricketcountup.new( '18 19 20', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 57,
        :stats => 3,
        :awards => []
      }
    end
    context 'award HATTRICK' do
      let(:round) { Round::Cricketcountup.new( '50 50 50', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 75,
        :stats => 3,
        :awards => [ 'HATTRICK', 'S-BULL', 'S-BULL', 'S-BULL' ]
      }
    end
    context 'award 5-Count HATTRICK' do
      let(:round) { Round::Cricketcountup.new( '50d 50d 50', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 125,
        :stats => 5,
        :awards => [
          '5-Count', 'HATTRICK',
          'D-BULL', 'D-BULL', 'S-BULL', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award THREEINTHEBLACK 6-Count' do
      let(:round) { Round::Cricketcountup.new( '50d 50d 50d', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 150,
        :stats => 6,
        :awards => [
          '6-Count', 'THREEINTHEBLACK', 'THREEINABED', 'HATTRICK',
          'D-BULL', 'D-BULL', 'D-BULL', 'DOUBLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '19t 19 19', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 95,
        :stats => 5,
        :awards => [ '5-Count', 'TRIPLE' ]
      }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 20t 1', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 114,
        :stats => 6,
        :awards => [ '6-Count', 'TRIPLE', 'TRIPLE' ]
      }
    end
    context 'award THREEINABED in double 6-Count' do
      let(:round) { Round::Cricketcountup.new( '16d 16d 16d', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 96,
        :stats => 6,
        :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ]
      }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 20t 15', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 129,
        :stats => 7,
        :awards => [ '7-Count', 'TRIPLE', 'TRIPLE' ]
      }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 20t 15d', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 144,
        :stats => 8,
        :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ]
      }
    end
    context 'award 9-Count' do
      let(:round) { Round::Cricketcountup.new( '20t 20t 19t', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 177,
        :stats => 9,
        :awards => [ '9-Count', 'TRIPLE', 'TRIPLE', 'TRIPLE' ]
      }
    end
    context 'award THREEINABED in triple 9-Count' do
      let(:round) { Round::Cricketcountup.new( '15t 15t 15t', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 135,
        :stats => 9,
        :awards => [ '9-Count', 'THREEINABED', 'TRIPLE', 'TRIPLE', 'TRIPLE' ]
      }
    end
    context 'award TON80 THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '20t 20t 20t', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 180,
        :stats => 9,
        :awards => [ 'TON80', 'THREEINABED', '9-Count', 'TRIPLE', 'TRIPLE', 'TRIPLE' ]
      }
    end
    context 'award THREEINABED in double not WHITEHOURSE' do
      let(:round) { Round::Cricketcountup.new( '20d 19d 18d', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 114,
        :stats => 6,
        :awards => [ '6-Count', 'DOUBLE', 'DOUBLE', 'DOUBLE' ]
        }
    end
    context 'award WHITEHOURSE' do
      let(:round) { Round::Cricketcountup.new( '20t 19t 18t', {:current_round => 8 } ) }
      include_examples 'check round', {
        :score => 171,
        :stats => 9,
        :awards => [ 'WHITEHOURSE', '9-Count', 'TRIPLE', 'TRIPLE', 'TRIPLE' ]
      }
    end
  end
end

