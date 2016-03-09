var req = new XMLHttpRequest();
req.open("GET", "/data.json", false);
req.send(null);
var datalist = JSON.parse( req.responseText );

var countupScores = datalist.filter(function(row,index,array){
  return ( row.game == 'countup' ) ? true : false;
});

var award_rows = countupScores.map(function(r){return r.award});
console.log(award_rows);

var bulls = 0;
award_rows.forEach(function(r){
  bulls += r["D-BULL"] || 0;
  bulls += r["S-BULL"] || 0;
});

console.log("bulls:", bulls);
var scores = countupScores.map(function(r){return r.score});
var total  = scores.reduce(function(x,y){ return x + y});
var average = total/scores.length;
console.log( "average:", average );
var maxScore = Math.max.apply(null, scores );
console.log( "max:", maxScore );

var bullRate = bulls / ( scores.length * 8 * 3 ) * 100;
console.log( "bull rate:", bullRate );

var chart = c3.generate({
  bindto: '#histgram',
  data: {
      columns: [
          ['data1', 30, 200, 100, 400, 150, 250],
          ['data2', 130, 100, 140, 200, 150, 50]
        ],
      type: 'bar'
    }
});
