require './lib/game.rb'
require 'rspec'

shared_examples 'check object' do |exp|
  it 'object name' do
    expect( game.class.to_s ).to eq( exp )
  end
end

shared_examples 'check calc_stats' do |args|
  it 'check calc_stats' do
    game.stats_scores = args[:scores]
    expect( game.calc_stats ).to eq( args[:exp] )
  end
end

shared_examples 'check round' do |exp|
  it 'last_round' do
    expect( game.last_round ).to eq ( exp[:last_round]  )
  end

  it 'incr_round and is_end' do
    expect( game.current_round ).to eq ( 1 )

    loop_count = exp[:last_round]
    ( 1..loop_count ).each{|n|
      game.incr_round( round )
    }

    expect( game.current_round ).to eq( exp[:last_round] + 1 )
    expect( game.is_end ).to be true
  end
end

shared_examples 'check pileup_score' do |args|
  it 'added round score' do
    expect( game.score ).to eq ( 0 )

    game.pileup_score( args[:round_score] )

    expect( game.score ).to eq ( args[:round_score] )

    game.pileup_score( args[:round_score] )

    expect( game.score ).to eq ( args[:round_score] * 2 )
  end
end

shared_examples 'check update_award' do |args|
  it 'check awards' do
    game.game_data["award"] = args[:past_awards] ||= []
    game.update_award( args[:current_awards] )
    expect( game.game_data["award"] ).to match( args[:expect_awards] )
  end
end

shared_examples 'check update_game_data' do |args|
  it 'check game_data' do
    game.score        = args[:score]
    game.stats_scores = args[:stats_scores]
    game.update_game_data

    expect( game.game_data ).to match( args[:exp] )
  end
end


describe Countup do
  describe 'functions' do
    let(:game) { Object.const_get('Countup').new }

    context 'created object' do
      include_examples 'check object', 'Countup'
    end

    context 'def calc_stats all 3' do
      include_examples 'check calc_stats',{
        :scores => [3,3,3,3,3,3,3,3],
        :exp    => 3
      }
    end

    context 'def calc_stats result is double' do
      include_examples 'check calc_stats',{
        :scores => [1,3,2,1,3,5,2,0],
        :exp    => 2.125
      }
    end

    context 'def pileup_score 10' do
      include_examples 'check pileup_score', { :round_score => 10 }
    end

    context 'def pileup_score 0' do
      include_examples 'check pileup_score', { :round_score => 0 }
    end

    context 'def update_award pileup award count' do
      include_examples 'check update_award', {
        :past_awards    => { "D-BULL" => 1, "S-BULL" => 1, "ROWTON" => 1 },
        :current_awards => ["D-BULL", "ROWTON"],
        :expect_awards  => { "D-BULL" => 2, "S-BULL" => 1, "ROWTON" => 2 }
      }
    end

    context 'def update_award new award added' do
      include_examples 'check update_award', {
        :past_awards    => { },
        :current_awards => ["D-BULL", "ROWTON"],
        :expect_awards  => { "D-BULL" => 1, "ROWTON" => 1 }
      }
    end

    context 'def update_award duplicate award in same round' do
      include_examples 'check update_award', {
        :past_awards    => { },
        :current_awards => ["D-BULL", "ROWTON", "ROWTON"],
        :expect_awards  => { "D-BULL" => 1, "ROWTON" => 2 }
      }
    end

    context 'def update_game_data' do

      before :each do
        today = Date.new( 2016, 4, 25 )
        allow(Date).to receive(:today).and_return( today )
      end

      include_examples 'check update_game_data', {
        :stats_scores => [50,50,20,20,20,20,20,20],
        :score => 500,
        :exp => {
          "date"  => "2016-04-25",
          "stats" => 27.5,
          "score" => 500,
          "game"  => "countup",
        }
      }
    end

    describe 'check round' do
      let(:round) { Round::Countup.new( '1 1 1', {:current_round => 1 } ) }
      include_examples 'check round', { :last_round => 8 }
    end

  end
end

describe Cricketcountup do
  describe 'functions' do
    let(:game) { Object.const_get('Cricketcountup').new }

    context 'created object' do
      include_examples 'check object', 'Cricketcountup'
    end

    context 'def calc_stats all 3' do
      include_examples 'check calc_stats',{
        :scores => [3,3,3,3,3,3,3,3],
        :exp    => 3
      }
    end

    context 'def calc_stats result is double' do
      include_examples 'check calc_stats',{
        :scores => [1,3,2,1,3,5,2,0],
        :exp    => 2.125
      }
    end

    context 'def pileup_score 10' do
      include_examples 'check pileup_score', { :round_score => 20 }
    end

    context 'def pileup_score 0' do
      include_examples 'check pileup_score', { :round_score => 0 }
    end

    context 'def update_award pileup award count' do
      include_examples 'check update_award', {
        :past_awards    => { "D-BULL" => 1, "S-BULL" => 1, "5-Count" => 1 },
        :current_awards => ["D-BULL", "5-Count"],
        :expect_awards  => { "D-BULL" => 2, "S-BULL" => 1, "5-Count" => 2 }
      }
    end

    context 'def update_award new award added' do
      include_examples 'check update_award', {
        :past_awards    => { },
        :current_awards => ["D-BULL", "5-Count"],
        :expect_awards  => { "D-BULL" => 1, "5-Count" => 1 }
      }
    end

    context 'def update_award duplicate award in same round' do
      include_examples 'check update_award', {
        :past_awards    => { },
        :current_awards => ["D-BULL", "5-Count", "5-Count"],
        :expect_awards  => { "D-BULL" => 1, "5-Count" => 2 }
      }
    end

    context 'def update_game_data' do

      before :each do
        today = Date.new( 2016, 4, 25 )
        allow(Date).to receive(:today).and_return( today )
      end

      include_examples 'check update_game_data', {
        :stats_scores => [3,3,2,2,3,4,2,2],
        :score => 400,
        :exp => {
          "date"  => "2016-04-25",
          "stats" => 2.625,
          "score" => 400,
          "game"  => "cricketcountup",
        }
      }
    end

    describe 'check round' do
      let(:round) { Round::Countup.new( '1 1 1', {:current_round => 1 } ) }
      include_examples 'check round', { :last_round => 8 }
    end

  end
end
