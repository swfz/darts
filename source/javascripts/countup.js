var chartdata4 = {

  "config": {
      "title": "stacked Chart",
      "subTitle": "Canvasを使った積み上げチャートです",
      "type": "stacked",
      "barWidth": 48,
      "colorSet": 
            ["red","#FF9114","#3CB000","#00A8A2","#0036C0","#C328FF","#FF34C0"],
      "bgGradient": {
                  "direction":"vertical",
                  "from":"#687478",
                  "to":"#222222"
                }
    },

  "data": [
      ["年度",2007,2008,2009,2010,2011,2012,2013],
      ["紅茶",435,332,524,688,774,825,999],
      ["コーヒー",600,335,584,333,457,788,900],
      ["ジュース",60,435,456,352,567,678,1260],
      ["ウーロン",200,123,312,200,402,300,512]
    ]
};
ccchart.init('countup', chartdata4)
