require './lib/round.rb'

describe Round::Countup do
  shared_examples 'check round' do |exp|
    it 'score' do
      expect( round.score ).to eq(exp[:score])
    end
    it 'awards' do
      expect( round.awards ).to match_array(exp[:awards])
    end
  end

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
