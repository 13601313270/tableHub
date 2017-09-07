//折线图
function line(id,parentDom){
    this.dom = $('<div id="'+id+'" style="width: 100%;height: 400px;"></div>');
    if(dom){
        this.parentDom = parentDom;
    }else{
        this.parentDom = $('.container');
    }
    var dom_ = this.dom;
    this.timeStamp = 0;
    parentDom.append(this.dom);
    this.render = function(){
        var this_ = this;
        var timeStamp = (new Date()).valueOf();
        this.timeStamp = timeStamp;
        window.setTimeout(function(){
            if(this_.timeStamp == timeStamp){
                var value = this_.value();
                var isAllStr = true;
                for(var i=0;i<value[0].length;i++){
                    if(typeof value[0][i]=='number'){
                        isAllStr = false;
                        break;
                    }
                }
                var data = [];
                if(isAllStr){
                    for(var j=0;j<value[0].length;j++){
                        data.push({type:'line',data:[]});
                    }
                    for(var i=0;i<value.length;i++){
                        for(var j=0;j<value[i].length;j++){
                            if(typeof value[i][j]=='string'){
                                data[j].name = value[i][j];
                            }else{
                                data[j].data.push(value[i][j]-30000);
                            }
                        }
                    }
                }else{
                    for(var i=0;i<value.length;i++){
                        var insert = {
                        };
                        for(var j=0;j<value[i].length;j++){
                            if(typeof value[i][j]=='string'){
                                insert.name = value[i][j];
                            }else{
                                insert.data.push(value[i][j]-30000);
                            }
                        }
                        data.push(insert);
                    }
                }
                var myChart = echarts.init(dom_[0]);
                var option = {
                    xAxis: {
                        type: 'category',
                        name: 'x',
                        splitLine: {show: false},
                        data: []
                    },
                    yAxis: {
                    },
                    series: [{
                        name:'a',
                        type:'line',
                        data:[],
                    }]
                };
                for(var i=0;i<data.length;i++){
                    option.xAxis.data.push(data[i].name);
                    option.series[0].data.push(data[i].data[0]);
                }
                myChart.setOption(option);
                pie.prototype.render.call(this_);
            }
        },100);
    }
    this.mes = function(obj,async){
        var mesData = new getMesOneData(obj,async);
        var this_ = this;
        mesData.getData(function(data){
            this_.value(data);
        });
    }
    this.setxAxis = function(){

    }
    this.mdw = function(obj,async){
        var mesData = new getMDW(obj,async);
        var this_ = this;
        mesData.getData(function(data){
            this_.value(data);
        });
    }
}
line.prototype = new obj();
function createLine(id,parent){
    alldoms[id] = new line(id,parent);
}