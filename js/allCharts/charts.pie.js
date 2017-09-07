//饼状图
function PIE(title,XtdLists,valueTdLists){
    this.top = 0;
    this.left = 0;
    this.width = 300;
    this.height = 300;
    this.title = title;
    this.XtdLists = XtdLists;
    this.bindEvent = [];
    this.listening = [];
    this.valueTdLists = valueTdLists;
    this.dom = $('<div type="PIE"><div style="width:100%;height:100%;"></div></div>');
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
                title : {
                    text: '请配置数据源',
                    x:'center'
                },
                tooltip : {
                    trigger: 'item',
                    formatter: "{a} <br/>{b} : {c} ({d}%)"
                },
                series : [
                    {
                        type:'pie',
                        radius : '55%',
                        center: ['50%', '60%'],
                        data:[{value:0,title:' '}]
                    }
                ]
            });
            return;
        }
        var X = this.XtdLists.get();
        var value = this.valueTdLists.get();
        var data = [];
        for(var i=0;i<value.length;i++){
            data.push({value:value[i], name:X[i]});
        }
        var title = this.title;
        if(title instanceof obj){
            title = title.get();
        }
        this.myChart.setOption({
            title : {
                text: title,
                x:'center'
            },
            series : [
                {
                    name:title,
                    type:'pie',
                    radius : '55%',
                    center: ['50%', '60%'],
                    data:data
                }
            ]
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
                $.post('',{
                    function:'updateChartsPos',
                    fileId:fileId,
                    tableNum:tableId,
                    chartsIndex:chartsIndex,
                    top:top,
                    left:left,
                    width:width,
                    height:height,
                },function(data){
                    if(data!=='-1'){
                    }else{
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
PIE.prototype = new obj('PIE');
chartsInit(PIE,'饼状图',{
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