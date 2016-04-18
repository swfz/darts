require './lib/round.rb'

shared_examples 'check round' do |exp|
  it 'score' do
    expect( round.score ).to eq(exp[:score])
  end
  it 'awards' do
    expect( round.awards ).to match_array(exp[:awards])
  end
end

describe Round::Countup do
  context 'standard 1 args in triple' do
    let(:round) { Round::Countup.new( '10t', 1 ) }
    include_examples 'check round', { :score => 30, :awards => [] }
  end
  context 'standard 1 args in double' do
    let(:round) { Round::Countup.new( '10d', 1 ) }
    include_examples 'check round', { :score => 20, :awards => [] }
  end
  context 'standard 3 args' do
    let(:round) { Round::Countup.new( '10 10 10', 1 ) }
    include_examples 'check round', { :score => 30, :awards => [] }
  end
  context 'standard 2 args' do
    let(:round) { Round::Countup.new( '10 10', 1 ) }
    include_examples 'check round', { :score => 20, :awards => [] }
  end
  context 'standard 1 args' do
    let(:round) { Round::Countup.new( '10', 1 ) }
    include_examples 'check round', { :score => 10, :awards => [] }
  end
  context 'award S-BULL' do
    let(:round) { Round::Countup.new( '1 50 1', 1 ) }
    include_examples 'check round', { :score => 52, :awards => [ 'S-BULL' ] }
  end
  context 'award D-BULL' do
    let(:round) { Round::Countup.new( '1 50d 1', 1 ) }
    include_examples 'check round', { :score => 52, :awards => [ 'D-BULL' ] }
  end
  context 'award ROWTON' do
    let(:round) { Round::Countup.new( '1 50d 50', 1 ) }
    include_examples 'check round', { :score => 101, :awards => [ 'D-BULL','S-BULL','ROWTON' ] }
  end
  context 'score is 100 not ROWTON' do
    let(:round) { Round::Countup.new( '50d 50', 1 ) }
    include_examples 'check round', { :score => 100, :awards => [ 'D-BULL','S-BULL' ] }
  end
  context 'award HATTRICK' do
    let(:round) { Round::Countup.new( '50 50 50d', 1 ) }
    include_examples 'check round', { :score => 150, :awards => [ 'D-BULL','S-BULL','S-BULL','HATTRICK' ] }
  end
  context 'award THREEINTHEBLACK' do
    let(:round) { Round::Countup.new( '50d 50d 50d', 1 ) }
    include_examples 'check round', { :score => 150, :awards => [ 'D-BULL','D-BULL','D-BULL','THREEINTHEBLACK' ] }
  end
  context 'award HIGHTON' do
    let(:round) { Round::Countup.new( '50 50d 19t', 1 ) }
    include_examples 'check round', { :score => 157, :awards => [ 'D-BULL','S-BULL','HIGHTON' ] }
  end
  context 'score is 150 not HIGHTON' do
    let(:round) { Round::Countup.new( '20t 20t 10t', 1 ) }
    include_examples 'check round', { :score => 150, :awards => [ 'ROWTON' ] }
  end
  context 'award TON80' do
    let(:round) { Round::Countup.new( '20t 20t 20t', 1 ) }
    include_examples 'check round', { :score => 180, :awards => [ 'TON80', 'THREEINABED' ] }
  end
  context 'award THREEINABED in double' do
    let(:round) { Round::Countup.new( '10d 10d 10d', 1 ) }
    include_examples 'check round', { :score => 60, :awards => [ 'THREEINABED' ] }
  end
  context 'award THREEINABED in triple' do
    let(:round) { Round::Countup.new( '10t 10t 10t', 1 ) }
    include_examples 'check round', { :score => 90, :awards => [ 'THREEINABED' ] }
  end
  context 'award THREEINABED in triple over HIGHTON' do
    let(:round) { Round::Countup.new( '19t 19t 19t', 1 ) }
    include_examples 'check round', { :score => 171, :awards => [ 'THREEINABED', 'HIGHTON' ] }
  end
  context 'award THREEINABED in triple over ROWTON' do
    let(:round) { Round::Countup.new( '15t 15t 15t', 1 ) }
    include_examples 'check round', { :score => 135, :awards => [ 'THREEINABED', 'ROWTON' ] }
  end
  context 'award THREEINABED in double over ROWTON' do
    let(:round) { Round::Countup.new( '20d 20d 20d', 1 ) }
    include_examples 'check round', { :score => 120, :awards => [ 'THREEINABED', 'ROWTON' ] }
  end
end

describe Round::Cricketcountup do
  describe 'args check' do
    context 'standard 1 args is point' do
      let(:round) { Round::Cricketcountup.new( '20', 1 ) }
      include_examples 'check round', { :score => 20, :awards => [] }
    end
    context 'standard 2 args is point' do
      let(:round) { Round::Cricketcountup.new( '20 20', 1 ) }
      include_examples 'check round', { :score => 40, :awards => [] }
    end
    context 'standard 3 args is point' do
      let(:round) { Round::Cricketcountup.new( '20 20 20', 1 ) }
      include_examples 'check round', { :score => 60, :awards => [] }
    end
    context 'standard 3 args is not point' do
      let(:round) { Round::Cricketcountup.new( '19 10 1', 1 ) }
      include_examples 'check round', { :score => 0, :awards => [] }
    end
    context 'standard 3 args complex' do
      let(:round) { Round::Cricketcountup.new( '19 20 1', 1 ) }
      include_examples 'check round', { :score => 20, :awards => [] }
    end
  end

  describe 'round1 target is 20' do
    context 'none award' do
      let(:round) { Round::Cricketcountup.new( '20 20 20', 1 ) }
      include_examples 'check round', { :score => 60, :awards => [] }
    end
    context 'award DOUBLE' do
      let(:round) { Round::Cricketcountup.new( '20d 1 1', 1 ) }
      include_examples 'check round', { :score => 40, :awards => [ 'DOUBLE' ] }
    end
    context 'award TRIPLE' do
      let(:round) { Round::Cricketcountup.new( '1 20t 1', 1 ) }
      include_examples 'check round', { :score => 60, :awards => [ 'TRIPLE' ] }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '20 20t 20', 1 ) }
      include_examples 'check round', { :score => 100, :awards => [ '5-Count', 'TRIPLE' ] }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '20t 20t 19', 1 ) }
      include_examples 'check round', { :score => 120, :awards => [ '6-Count', 'TRIPLE', 'TRIPLE' ] }
    end
    context 'award THREEINABED 6-Count' do
      let(:round) { Round::Cricketcountup.new( '20d 20d 20d', 1 ) }
      include_examples 'check round', { :score => 120, :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '20t 20t 20', 1 ) }
      include_examples 'check round', { :score => 140, :awards => [ '7-Count', 'TRIPLE', 'TRIPLE' ] }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '20t 20t 20d', 1 ) }
      include_examples 'check round', { :score => 160, :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award TON80 THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '20t 20t 20t', 1 ) }
      include_examples 'check round', { :score => 180, :awards => [ 'TON80', 'THREEINABED', '9-Count', 'TRIPLE', 'TRIPLE', 'TRIPLE' ] }
    end
  end
  describe 'round2 target is 19' do
    context 'none award' do
      let(:round) { Round::Cricketcountup.new( '19 19 19', 2 ) }
      include_examples 'check round', { :score => 57, :awards => [] }
    end
    context 'award DOUBLE' do
      let(:round) { Round::Cricketcountup.new( '19d 1 1', 2 ) }
      include_examples 'check round', { :score => 38, :awards => [ 'DOUBLE' ] }
    end
    context 'award TRIPLE' do
      let(:round) { Round::Cricketcountup.new( '19t 1 1', 2 ) }
      include_examples 'check round', { :score => 57, :awards => [ 'TRIPLE' ] }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '19t 19d 1', 2 ) }
      include_examples 'check round', { :score => 95, :awards => [ '5-Count', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '19t 19d 19', 2 ) }
      include_examples 'check round', { :score => 114, :awards => [ '6-Count', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award THREEINABED 6-Count' do
      let(:round) { Round::Cricketcountup.new( '19d 19d 19d', 2 ) }
      include_examples 'check round', { :score => 114, :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '19t 19d 19d', 2 ) }
      include_examples 'check round', { :score => 133, :awards => [ '7-Count', 'TRIPLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '19t 19t 19d', 2 ) }
      include_examples 'check round', { :score => 152, :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '19t 19t 19t', 2 ) }
      include_examples 'check round', { :score => 171, :awards => [ '9-Count', 'THREEINABED', 'TRIPLE', 'TRIPLE', 'TRIPLE' ] }
    end
  end
  describe 'round3 target is 18' do
    context 'none award' do
      let(:round) { Round::Cricketcountup.new( '18 18 18', 3 ) }
      include_examples 'check round', { :score => 54, :awards => [] }
    end
    context 'award DOUBLE' do
      let(:round) { Round::Cricketcountup.new( '18d 1 1', 3 ) }
      include_examples 'check round', { :score => 36, :awards => [ 'DOUBLE' ] }
    end
    context 'award TRIPLE' do
      let(:round) { Round::Cricketcountup.new( '18t 1 1', 3 ) }
      include_examples 'check round', { :score => 54, :awards => [ 'TRIPLE' ] }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 18d 1', 3 ) }
      include_examples 'check round', { :score => 90, :awards => [ '5-Count', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 18d 18', 3 ) }
      include_examples 'check round', { :score => 108, :awards => [ '6-Count', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award THREEINABED 6-Count' do
      let(:round) { Round::Cricketcountup.new( '18d 18d 18d', 3 ) }
      include_examples 'check round', { :score => 108, :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 18d 18d', 3 ) }
      include_examples 'check round', { :score => 126, :awards => [ '7-Count', 'TRIPLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 18t 18d', 3 ) }
      include_examples 'check round', { :score => 144, :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 18t 18t', 3 ) }
      include_examples 'check round', { :score => 162, :awards => [ '9-Count', 'THREEINABED', 'TRIPLE', 'TRIPLE', 'TRIPLE' ] }
    end
  end
  describe 'round4 target is 17' do
    context 'none award' do
      let(:round) { Round::Cricketcountup.new( '17 17 17', 4 ) }
      include_examples 'check round', { :score => 51, :awards => [] }
    end
    context 'award DOUBLE' do
      let(:round) { Round::Cricketcountup.new( '17d 1 1', 4 ) }
      include_examples 'check round', { :score => 34, :awards => [ 'DOUBLE' ] }
    end
    context 'award TRIPLE' do
      let(:round) { Round::Cricketcountup.new( '17t 1 1', 4 ) }
      include_examples 'check round', { :score => 51, :awards => [ 'TRIPLE' ] }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '17t 17d 1', 4 ) }
      include_examples 'check round', { :score => 85, :awards => [ '5-Count', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '17t 17d 17', 4 ) }
      include_examples 'check round', { :score => 102, :awards => [ '6-Count', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award THREEINABED 6-Count' do
      let(:round) { Round::Cricketcountup.new( '17d 17d 17d', 4 ) }
      include_examples 'check round', { :score => 102, :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '17t 17d 17d', 4 ) }
      include_examples 'check round', { :score => 119, :awards => [ '7-Count', 'TRIPLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '17t 17t 17d', 4 ) }
      include_examples 'check round', { :score => 136, :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '17t 17t 17t', 4 ) }
      include_examples 'check round', { :score => 153, :awards => [ '9-Count', 'THREEINABED', 'TRIPLE', 'TRIPLE', 'TRIPLE' ] }
    end
  end
  describe 'round5 target is 16' do
    context 'none award' do
      let(:round) { Round::Cricketcountup.new( '16 16 16', 5 ) }
      include_examples 'check round', { :score => 48, :awards => [] }
    end
    context 'award DOUBLE' do
      let(:round) { Round::Cricketcountup.new( '16d 1 1', 5 ) }
      include_examples 'check round', { :score => 32, :awards => [ 'DOUBLE' ] }
    end
    context 'award TRIPLE' do
      let(:round) { Round::Cricketcountup.new( '16t 1 1', 5 ) }
      include_examples 'check round', { :score => 48, :awards => [ 'TRIPLE' ] }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '16t 16d 1', 5 ) }
      include_examples 'check round', { :score => 80, :awards => [ '5-Count', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '16t 16d 16', 5 ) }
      include_examples 'check round', { :score => 96, :awards => [ '6-Count', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award THREEINABED 6-Count' do
      let(:round) { Round::Cricketcountup.new( '16d 16d 16d', 5 ) }
      include_examples 'check round', { :score => 96, :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '16t 16d 16d', 5 ) }
      include_examples 'check round', { :score => 112, :awards => [ '7-Count', 'TRIPLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '16t 16t 16d', 5 ) }
      include_examples 'check round', { :score => 128, :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '16t 16t 16t', 5 ) }
      include_examples 'check round', { :score => 144, :awards => [ '9-Count', 'THREEINABED', 'TRIPLE', 'TRIPLE', 'TRIPLE' ] }
    end
  end
  describe 'round6 target is 15' do
    context 'none award' do
      let(:round) { Round::Cricketcountup.new( '15 15 15', 6 ) }
      include_examples 'check round', { :score => 45, :awards => [] }
    end
    context 'award DOUBLE' do
      let(:round) { Round::Cricketcountup.new( '15d 1 1', 6 ) }
      include_examples 'check round', { :score => 30, :awards => [ 'DOUBLE' ] }
    end
    context 'award TRIPLE' do
      let(:round) { Round::Cricketcountup.new( '15t 1 1', 6 ) }
      include_examples 'check round', { :score => 45, :awards => [ 'TRIPLE' ] }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '15t 15d 1', 6 ) }
      include_examples 'check round', { :score => 75, :awards => [ '5-Count', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '15t 15d 15', 6 ) }
      include_examples 'check round', { :score => 90, :awards => [ '6-Count', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award THREEINABED 6-Count' do
      let(:round) { Round::Cricketcountup.new( '15d 15d 15d', 6 ) }
      include_examples 'check round', { :score => 90, :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '15t 15d 15d', 6 ) }
      include_examples 'check round', { :score => 105, :awards => [ '7-Count', 'TRIPLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '15t 15t 15d', 6 ) }
      include_examples 'check round', { :score => 120, :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '15t 15t 15t', 6 ) }
      include_examples 'check round', { :score => 135, :awards => [ '9-Count', 'THREEINABED', 'TRIPLE', 'TRIPLE', 'TRIPLE' ] }
    end
  end
  describe 'round7 target is BULL' do
    context 'none point' do
      let(:round) { Round::Cricketcountup.new( '15 16 17', 7 ) }
      include_examples 'check round', { :score => 0, :awards => [] }
    end
    context 'none point2' do
      let(:round) { Round::Cricketcountup.new( '18 19 20', 7 ) }
      include_examples 'check round', { :score => 0, :awards => [] }
    end
    context 'award S-BULL' do
      let(:round) { Round::Cricketcountup.new( '50 1 1', 7 ) }
      include_examples 'check round', { :score => 25, :awards => [ 'S-BULL' ] }
    end
    context 'award D-BULL' do
      let(:round) { Round::Cricketcountup.new( '50d 1 1', 7 ) }
      include_examples 'check round', { :score => 50, :awards => [ 'D-BULL', 'DOUBLE' ] }
    end
    context 'award HATTRICK' do
      let(:round) { Round::Cricketcountup.new( '50 50 50', 7 ) }
      include_examples 'check round', {
        :score => 75,
        :awards => [ 'HATTRICK', 'S-BULL', 'S-BULL', 'S-BULL' ]
      }
    end
    context 'award 5-Count HATTRICK' do
      let(:round) { Round::Cricketcountup.new( '50d 50d 50', 7 ) }
      include_examples 'check round', {
        :score => 125,
        :awards => [
          '5-Count', 'HATTRICK',
          'D-BULL', 'D-BULL', 'S-BULL', 'DOUBLE', 'DOUBLE'
        ]
      }
    end
    context 'award THREEINTHEBLACK 6-Count' do
      let(:round) { Round::Cricketcountup.new( '50d 50d 50d', 7 ) }
      include_examples 'check round', {
        :score => 150,
        :awards => [
          '6-Count', 'THREEINTHEBLACK', 'THREEINABED', 'HATTRICK',
          'D-BULL', 'D-BULL', 'D-BULL', 'DOUBLE', 'DOUBLE', 'DOUBLE'
        ]
      }
    end
  end
  describe 'round8 target is ALL CRICKET Number' do
    context 'none point' do
      let(:round) { Round::Cricketcountup.new( '14 1 10', 8 ) }
      include_examples 'check round', { :score => 0, :awards => [] }
    end
    context 'standard point 15 16 17' do
      let(:round) { Round::Cricketcountup.new( '15 16 17', 8 ) }
      include_examples 'check round', { :score => 48, :awards => [] }
    end
    context 'standard point 18 19 20' do
      let(:round) { Round::Cricketcountup.new( '18 19 20', 8 ) }
      include_examples 'check round', { :score => 57, :awards => [] }
    end
    context 'award HATTRICK' do
      let(:round) { Round::Cricketcountup.new( '50 50 50', 7 ) }
      include_examples 'check round', {
        :score => 75,
        :awards => [ 'HATTRICK', 'S-BULL', 'S-BULL', 'S-BULL' ]
      }
    end
    context 'award 5-Count HATTRICK' do
      let(:round) { Round::Cricketcountup.new( '50d 50d 50', 7 ) }
      include_examples 'check round', {
        :score => 125,
        :awards => [
          '5-Count', 'HATTRICK',
          'D-BULL', 'D-BULL', 'S-BULL', 'DOUBLE', 'DOUBLE'
        ]
      }
    end
    context 'award THREEINTHEBLACK 6-Count' do
      let(:round) { Round::Cricketcountup.new( '50d 50d 50d', 7 ) }
      include_examples 'check round', {
        :score => 150,
        :awards => [
          '6-Count', 'THREEINTHEBLACK', 'THREEINABED', 'HATTRICK',
          'D-BULL', 'D-BULL', 'D-BULL', 'DOUBLE', 'DOUBLE', 'DOUBLE'
        ]
      }
    end
    context 'award 5-Count' do
      let(:round) { Round::Cricketcountup.new( '19t 19 19', 8 ) }
      include_examples 'check round', { :score => 95, :awards => [ '5-Count', 'TRIPLE' ] }
    end
    context 'award 6-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 20t 1', 8 ) }
      include_examples 'check round', { :score => 114, :awards => [ '6-Count', 'TRIPLE', 'TRIPLE' ] }
    end
    context 'award THREEINABED in double 6-Count' do
      let(:round) { Round::Cricketcountup.new( '16d 16d 16d', 5 ) }
      include_examples 'check round', { :score => 96, :awards => [ '6-Count', 'THREEINABED', 'DOUBLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award 7-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 20t 15', 8 ) }
      include_examples 'check round', { :score => 129, :awards => [ '7-Count', 'TRIPLE', 'TRIPLE' ] }
    end
    context 'award 8-Count' do
      let(:round) { Round::Cricketcountup.new( '18t 20t 15d', 8 ) }
      include_examples 'check round', { :score => 144, :awards => [ '8-Count', 'TRIPLE', 'TRIPLE', 'DOUBLE' ] }
    end
    context 'award 9-Count' do
      let(:round) { Round::Cricketcountup.new( '20t 20t 19t', 8 ) }
      include_examples 'check round', { :score => 177, :awards => [ '9-Count', 'TRIPLE', 'TRIPLE', 'TRIPLE' ] }
    end
    context 'award THREEINABED in triple 9-Count' do
      let(:round) { Round::Cricketcountup.new( '15t 15t 15t', 6 ) }
      include_examples 'check round', { :score => 135, :awards => [ '9-Count', 'THREEINABED', 'TRIPLE', 'TRIPLE', 'TRIPLE' ] }
    end
    context 'award TON80 THREEINABED 9-Count' do
      let(:round) { Round::Cricketcountup.new( '20t 20t 20t', 1 ) }
      include_examples 'check round', { :score => 180, :awards => [ 'TON80', 'THREEINABED', '9-Count', 'TRIPLE', 'TRIPLE', 'TRIPLE' ] }
    end
    context 'award THREEINABED in double not WHITEHOURSE' do
      let(:round) { Round::Cricketcountup.new( '20d 19d 18d', 8 ) }
      include_examples 'check round', { :score => 114, :awards => [ '6-Count', 'DOUBLE', 'DOUBLE', 'DOUBLE' ] }
    end
    context 'award WHITEHOURSE' do
      let(:round) { Round::Cricketcountup.new( '20t 19t 18t', 8 ) }
      include_examples 'check round', { :score => 171, :awards => [ 'WHITEHOURSE', '9-Count', 'TRIPLE', 'TRIPLE', 'TRIPLE' ] }
    end
  end
  #TODO get_stats_score
end

