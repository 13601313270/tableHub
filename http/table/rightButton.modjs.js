var allRightAction = {
    AddColumn:function(){
        console.log('添加列');
        console.log(this);
        //$.post('/trafficMES/myData.php',{
//                    sAction:'addColumn',
//                    sFileId:fileId,
//                    sbeforeColumn:selectId.split(':')[1],
//                },function(result){
//                    if(result==1){
//                        setTimeout(function(){
////                            location.href = location.href.replace('&edit=true','').replace(/&scrollLeft=(\d+)/,'')+'&edit=true&scrollLeft='+parseInt($('#myTabContent .active').scrollLeft());
//                        },100);
//                    }
//                });
    },
    DeleteColumn:function(){
        console.log('删除列');
        console.log(this);
        //                $.post('/trafficMES/myData.php',{
//                    sAction:'deleteColumn',
//                    sFileId:fileId,
//                    sDeleteColumn:selectId.split(':')[1],
//                },function(result){
//                    if(result==1){
//                        setTimeout(function(){
////                            location.href = location.href.replace('&edit=true','').replace(/&scrollLeft=(\d+)/,'')+'&edit=true&scrollLeft='+parseInt($('#myTabContent .active').scrollLeft());
//                        },100);
//                    }
//                });
    },
    deleteCharts:function(){
        var tableNum = parseInt($('#myTabContent>.tab-pane.active').attr('data-tableid'));
        var chartIndex = $(this).attr('index');
        $.post('',{
            function:'deleteChart',
            fileId:fileId,
            tableNum:tableNum,
            chartsIndex:chartIndex,
        },function(result){
            if(result==1){
                var thisObj = allEcharts[tableNum][chartIndex];
                var listenCount = thisObj.listening.length;
                for(var i=listenCount-1;i>=0;i--){
                    if(thisObj.listening[i] instanceof obj){
                        thisObj.listening[i].unBind(thisObj);
                    }
                }
                thisObj.dom.remove();
                allEcharts[tableNum].splice(chartIndex,1);
                $('#myTabContent>.tab-pane.active .allCharts>*').each(function(){
                    if(parseInt($(this).attr('index'))>chartIndex){
                        $(this).attr('index',parseInt($(this).attr('index'))-1);
                    }
                });
            }
        });
        console.log(this);
    }
}
var allRightActionConfig = {
    '.lieNum':{
        AddColumn:{
            title:'添加列',
        },
        DeleteColumn:{
            title:'删除列',
        }
    },
    '.allCharts>div':{
        deleteCharts:{
            title:'删除图表',
        },
    }
};