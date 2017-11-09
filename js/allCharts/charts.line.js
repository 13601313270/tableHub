//饼状图
function LINE(title,XtdLists,valueTdLists){
    this.top = 0;
    this.left = 0;
    this.width = 300;
    this.height = 300;
    this.title = title;
    this.XtdLists = XtdLists;
    this.bindEvent = [];
    this.listening = [];
    this.valueTdLists = valueTdLists;
    this.dom = $('<div type="LINE"><div style="width:100%;height:100%;"></div></div>');
    this.dom.css({
        backgroundColor:'white',
        position:'absolute',
        zIndex:3,
        border:'solid 1px #6f6f6f',
        top:this.top,
        left:this.left,
        width:this.width,
        height:this.height,
    });
    this.myChart = null;
    this.render = function(){
        this.dom.css({
            top:this.top,
            left:this.left,
            width:this.width,
            height:this.height,
        });
        var domTemp = this.dom.find('>div');
        if(domTemp.width()!==domTemp.find('>div').width() || domTemp.height()!==domTemp.find('>div').height()){
            this.myChart.resize();
        }
        if((this.XtdLists instanceof tdList)==false){
            this.myChart.setOption({
                title: {
                    text: '',
                },
                tooltip: {trigger: 'axis'},
                xAxis:  {
                    type: 'category',
                    boundaryGap: false,
                    data: ['']
                },
                yAxis: {type: 'value',},
                series: [
                    {
                        name:'最高气温',
                        type:'line',
                        data:[0]
                    }
                ]
            });
            return;
        }
        var X = this.XtdLists.get();
        for(var i=0;i< X.length;i++){
            if(X[i]===undefined){
                X[i] = 0;
            }
            X[i] = X[i].toString();
        }
        var value = this.valueTdLists.get();
        for(i=0;i< X.length;i++){
            if(value[i]===undefined){
                value[i] = 0;
            }
            value[i] = parseInt(value[i]);
        }
        var title = this.title;
        if(title instanceof obj){
            title = title.get();
        }
        this.myChart.setOption({
            title: {text:title,x:'center'},
            tooltip: {trigger: 'axis'},
            grid: {
                left: 0,
                right: 0,
                bottom: 0,
                top:0,
            },
            xAxis:  {type: 'category', boundaryGap: false, data: X},
            yAxis: {type: 'value'},
            series: [{name:title, type:'line', data:value}]
        });
    };
    (function(){
        var $this = this;
        var mDown = false;
        var move = false;
        var positionX;
        var positionY;
        this.mousedown(function(e){
            if(isCanEdit && $('#tablePanel').is('.edit')){
                $this.moving = true;
                mDown = true;
                move = false;
                positionX = $this.position().left-e.pageX;
                positionY = $this.position().top-e.pageY;
            }
            return false;
        });
        $(document).mouseup(function(e){
            mDown = false;
            if($this.moving && move){
                var type = $this.attr('type');
                var tableId = $('#myTabContent .active').data('tableid');
                var chartsIndex = $this.attr('index');
                var top = parseInt($this.css('top'));
                var left = parseInt($this.css('left'));
                var width = parseInt($this.css('width'));
                var height = parseInt($this.css('height'));
                allEcharts[tableId][chartsIndex].top = top;
                allEcharts[tableId][chartsIndex].left = left;
                $.post('/action/table.html',{
                    function:'updateChartsPos',
                    fileId:fileId,
                    tableNum:tableId,
                    chartsIndex:chartsIndex,
                    top:top,
                    left:left,
                    width:width,
                    height:height,
                },function(data){
                    if(data!=='1'){
                        alert('样式服务器同步失败');
                    }
                });
            }
            $this.moving = false;
        });
        $(document).mousemove(function(e){
            var top = positionY+e.pageY;
            var left = positionX+e.pageX;
            if(top<0){top=0}
            if(left<0){left=0}
            if(mDown){
                move = true;
                $this.css({left:left, top:top});
            }
        });
    }).call(this.dom);
}
LINE.prototype = new obj('LINE');
chartsInit(LINE,'饼状图',{
    params:{
        title:{
            title:'标题',
            dataType:'int',
            default:0,
        },
        XtdLists:{
            title:'数据标题轴',
            dataType:'int',
            default:0,
        },
        valueTdLists:{
            title:'数据值',
            dataType:'int',
            default:0,
        }
    },
    save:function(obj){
        return [obj.title,obj.XtdLists,obj.valueTdLists];
    }
});