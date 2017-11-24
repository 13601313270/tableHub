<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,minimal-ui">
    <link href="//cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <link href="//cdn.bootcss.com/spectrum/1.8.0/spectrum.min.css" rel="stylesheet">
    <script type="application/javascript" src="https://cdn.bootcss.com/jquery/3.2.1/jquery.js"></script>
    <script type="application/javascript" src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script type="application/javascript" src="//www.tablehub.cn/js/dataTable.js"></script>
    <link href="https://cdn.bootcss.com/jqueryui/1.12.1/jquery-ui.css" rel="stylesheet">
    <link href="https://at.alicdn.com/t/font_384848_27ac7fmkzxzdunmi.css" rel="stylesheet">
    <link href="https://cdn.bootcss.com/bootstrap-colorpicker/2.5.1/css/bootstrap-colorpicker.min.css" rel="stylesheet">
    <script src="https://cdn.bootcss.com/jqueryui/1.12.1/jquery-ui.js"></script>
    <script src="https://cdn.bootcss.com/spectrum/1.8.0/spectrum.min.js"></script>
    <script src="https://cdn.bootcss.com/spectrum/1.8.0/i18n/jquery.spectrum-zh-cn.min.js"></script>
    <script type="application/javascript" src="https://cdn.bootcss.com/jquery-datetimepicker/2.5.4/build/jquery.datetimepicker.full.min.js"></script>
    <script type="application/javascript" src="//www.tablehub.cn/js/evalObjAndStr.js"></script>
    <script type="application/javascript" src="//www.tablehub.cn/js/dragging.js"></script>
    <script src="https://cdn.bootcss.com/echarts/2.2.7/echarts.js"></script>
    <script type="application/javascript" src="http://js.tablehub.cn/tablePlugins/all.js"></script>
    <script>
        var fileId = window.location.href.match(/\/table\/(\d+)\.html/)[1];
        var isCanEdit = false;
    </script>
    <style>
        body{
            background-color: #e6e6e6;
        }
        .container{
            background-color: #e6e6e6;width:100%;height:100%;margin: 0;padding: 10px;position: relative;
        }
        .table{
            width:0!important;
            margin-top: 0;
            background-color: white;
            table-layout: fixed;
        }
        .table>thead>tr>th{
            width:100px;
        }
        .table>tbody>tr>td{
            width:100px;
            overflow: hidden;
        }
        .idNum{
            background-color: #c3c3c3;border-right:solid 3px #929292;min-width:30px;
        }
        .tableBody{
            margin-left:0px;width:100%;height:100%;overflow: auto;margin-top:0px;
        }
        .tableBody .input-group{
            width:98%;margin-left: 1%;
        }
        .edit .tableBody{
            margin-left:80px;width: calc(100% - 80px);height:calc(100% - 39px);overflow: scroll;margin-top: 39px;cursor: cell;
        }
        .tableRow{
            display: none;position:absolute;left:0;width:80px;top:39px;height:calc(100% - 39px);overflow: hidden;
        }
        .tableThead{
            display: none;
        }
        .edit .table{
            margin: 0 0;
        }
        .edit .tableRow{
            display: block;
        }
        .edit .tableThead{
            display: block;
        }
        #myTabContent{
            position:relative;height: calc(100% - 40px);
        }
        #myTabContent .tab-pane{
            overflow: auto;width: 100%;height: 100%;padding-top: 5px;
        }
    </style>
</head>
<body>
<style>
    .trMain{
        background-color: white;
    }
    .trTwo{
        display: none;
        background-color: #EEEEEE;
    }
    .trThree{
        background-color: #E8E8E8;
    }
    .addButton{
        float: right;
    }
    .addButton:after{
        content: '+';
    }
    .table th, .table td{
        text-align: center;
    }
    .table>tbody>tr{
        height: 37px;
    }
    .table>thead{
        background-color: #c3c3c3;
    }
    .edit .editTd{
        background-color: #e5f2ff;
        /*border:solid 2px #0000b8;*/
    }
    .edit .editTdtop{
        border-top:solid 2px #0000b8;
    }
    .edit .editTdbottom{
        border-bottom:solid 2px #0000b8;
    }
    .edit .editTdleft{
        border-left:solid 2px #0000b8;
    }
    .edit .editTdright{
        border-right:solid 2px #0000b8;
    }
    .tableThead thead>tr>th{
        min-width: 60px;border: 1px solid #ddd;white-space:nowrap;vertical-align: middle;padding:0;height:37px;
    }
    .table>tbody>tr>td{
        min-width: 60px;border: 1px solid #ddd;white-space:nowrap;vertical-align: middle;padding:0;height:37px;
    }
    .tableThead>thead th{
        border-bottom: solid 3px #929292!important;
    }
    .tableThead .table>thead>tr>.lieNum{
        position:relative;
    }
    .tableThead .table>thead>tr>.lieNum>div{
        cursor: ew-resize;
        position: absolute;
        right: 0;
        top: 0;
        height: 100%;
        width: 5px;
    }
    .table>tbody>tr>.mergeTd{
        white-space:initial
    }
    .tableBody tr{
        background-color: white;
    }
    .tableBody thead{
        height: 20px;
    }
    .tableBody .table{
        margin-top: -16px;
    }
    .tableBody .table>thead>tr>th{
        border-bottom: none;
    }
    .styleAllSelect{
        float:left;width:60px;height:20px;margin:2px;background-color: white;
    }
    .styleSelect{
        border: solid 1px black;
    }
    .idNumOn{
        background-color:#a7a7a7!important;
        box-shadow: inset 6px -1px 20px 1px #909090;
        color: #e8e8e8;
    }
    .lieNumOn{
        background-color: #a7a7a7!important;
        box-shadow: inset 0px 6px 20px 3px #909090;
        color: #e8e8e8;
    }
    .addTable{
        font-family: iconfont;
        line-height: 40px;
        border: solid 1px rgba(255, 255, 255, 0);
        border-left: solid 1px #bdbdbd;
        width: 50px;
        font-size: 18px;
        text-align: center;
        cursor: pointer;
    }
    .addTable:hover{
        background-color: #e6e6e6;
        border: solid 1px #b5b5b5;
        border-radius: 2px;
    }
    .table td .tdInsertDiv{
        display: table;width: 100%;
    }
    .table td .tdInsertDiv>div{
        display: table-cell;
    }
    .table td .tdInsertDiv>div:nth-child(2){
        white-space: normal;
        display: block;
        height:1rem;
    }
    .table td .tdInsertDiv>div:nth-child(2)>span{
        /*max-width: 100px;*/
        display: inline-block;
    }
    .table td .tdInsertDiv>div:first-child{
        text-align: left;
    }
    .table td .tdInsertDiv>div:last-child{
        text-align: right;
    }
</style>
<div id="tablePanel">
    {include file="table/toos.tpl"}
    <div id="myTabContentParent">
        <ul class="allTableSelect nav nav-tabs"></ul>
        <div id="myTabContent" class="tab-content"></div>
    </div>
</div>
<style>
    .footer{
        position:fixed;height: 12px;font-size: 12px;bottom: 5px;left:10px;color: #929292;
    }
</style>
<div class="footer">tablehub.cn&nbsp;&nbsp;京ICP备17039360号</div>
<script>
    $('.editChange').click(function(){
        var lieAddCount = 2;//增加
        if($('.editChange').parent().is('.closeEdit')){
            $('.editChange').parent().attr('class','container openEdit');
            if(lieAddCount>0){
                $('#myTabContent .tab-pane').each(function(){
                    for(var i=0;i<lieAddCount;i++){
                        var lieNum = getCellTemp2(0,$(this).find('.tableThead table thead tr th').length+1).match(/([A-Z]*)(\d+)/)[1];
                        var headTdHtml = '<th class="lieNum" lienum="'+lieNum+'" style="position: relative; overflow: hidden;">'+
                                lieNum+
                                '<div style="position: absolute; cursor: ew-resize;"></div>' +
                                '</th>';
                        var bodyTheadHtml = '<th class="lieNum" lienum="'+lieNum+'"></th>';
                        $(this).find('.tableThead table thead tr').append($(headTdHtml));
                        $(this).find('.tableBody table thead tr').append($(bodyTheadHtml));
                    }
                });
                $('#myTabContent .tableBody table tbody tr').each(function(){
                    for(var i=0;i<lieAddCount;i++){
                        var newTd = $('<td></td>');
                        newTd.attr('hang',$(this).index()+1);
                        newTd.attr('lie',$(this).find('>td').length+1);
                        $(this).append(newTd);
                    }
                });
            }
            $('#tablePanel').addClass('edit');
        }else{
            $('.editChange').parent().attr('class','container closeEdit');
            if(lieAddCount>0){
                $('#myTabContent .tableThead table').each(function(){
                    for(var i=0;i<lieAddCount;i++){
                        $(this).find('thead tr th:last').remove();
                    }
                });
                $('#myTabContent .tableBody table thead tr').each(function(){
                    for (var i=0;i<lieAddCount;i++){
                        $(this).find('th:last').remove();
                    }
                });
                $('#myTabContent .tableBody table tbody tr').each(function(){
                    for (var i=0;i<lieAddCount;i++){
                        $(this).find('td:last').remove();
                    }
                });
            }
            $('#tablePanel').removeClass('edit');
//        location.href = location.href.replace('&edit=true','').replace(/&scrollLeft=(\d+)/,'');
            $('#dataFloat').hide();
        }
    });
    var tdData = [];
    var allEcharts = [];
    //表格完成对象
    function tableReady(){
    }
    tableReady.prototype = new obj();
    var readyObj = new tableReady();
    function writeTd(tableNum,tdPos,str,xfIndex){
        if(allTD['td:'+tableNum+'!'+tdPos]==undefined){
            var thisTd = new td(tableNum,tdPos);
        }else{
            var thisTd = allTD['td:'+tableNum+'!'+tdPos];
        }
        thisTd.xfIndex = xfIndex;
        if(str===null){
            thisTd.set('');
        }else if(typeof str=='string' && str.substr(0,1)=='='){
            str = str.match(/=(.*)/)[1];
            thisTd.set(getEvalObj(tableNum,str,true));
        }else{
            thisTd.set(str);
        }
        readyObj.bind(thisTd);
    }
    function createCss(i,item){
        {literal}
        var strItem = "[cell_xf=\""+i+"\"]{\n";
        if(item.font){
            if(item.font.color){
                strItem+='color:#'+item.font.color.slice(2)+';\n';
            }
            if(item.font.bold===true||item.font.bold===1){
                strItem+='font-weight:bold;\n';
            }
            if(item.font.size){
                strItem+='font-size:'+parseInt(item.font.size*1.2)+'px;\n';
            }
            if(item.font.underline==='single'){
                strItem+='text-decoration:underline;\n';
            }
            if(item.font.italic===true||item.font.italic===1){
                strItem+='font-style: italic;\n';
            }
        }
        if(item.fill && item.fill.fillType!=='none'){
            if(item.fill.startColor){
                strItem+='background-color:#'+item.fill.startColor.slice(2)+';\n';
            }
        }
        if(item.alignment){
            if(item.alignment.horizontal=='left'){
                strItem+='text-align: left!important;\n';
            }else if(item.alignment.horizontal=='right'){
                strItem+='text-align: right!important;\n';
            }else if(item.alignment.horizontal=='center'){
                strItem+='text-align: center!important;\n';
            }else if(item.alignment.horizontal=='general'){
//                    strItem+='text-align: center;\n';
            }
        }
        strItem += "}\n";
        return strItem;
        {/literal}
    }
    function rewriteExcel(styleList,dataList){
        window.getCellXfCollection = styleList;
        //单元格样式
        if(getCellXfCollection!==null && getCellXfCollection.length>0){
            var nod = document.createElement("style");
            nod.type="text/css";
            $(nod).attr('td_css_list',1);
            var str = "";
            for(var i=0;i<getCellXfCollection.length;i++){
                var item = getCellXfCollection[i];
                str+=createCss(i,item);
            }
            if(nod.styleSheet){ //ie下
                nod.styleSheet.cssText = str;
            } else {
                nod.innerHTML = str;
            }
            document.getElementsByTagName("head")[0].appendChild(nod);
        }
        //单元格数据
        var allFileData =  dataList;
        function setTdWidth(tableNum,thNum,width){
            dom('appMain'+tableNum).thead.find('thead th').eq(thNum-1).css({
                width:width*10
            });
            dom('appMain'+tableNum).table.find('tbody tr:eq(0) td').eq(thNum-1).css({
                width:width*10
            });
        }
        function initMerge(tableNum,mergeData){
            for(var i in mergeData){
                var beginAndEnd = i.split(':');
                var begin = getCellTemp(beginAndEnd[0]);
                var end = getCellTemp(beginAndEnd[1]);

                dom('appMain'+tableNum).td(beginAndEnd[0]).dom.attr('rowspan',end[0]-begin[0]+1);
                dom('appMain'+tableNum).td(getCellTemp2(begin[0],begin[1])).dom.attr('colspan',end[1]-begin[1]+1);
                dom('appMain'+tableNum).td(beginAndEnd[0]).dom.addClass('mergeTd');

                for(var tr=begin[0];tr<=end[0];tr++){
                    var firstTdWidth = 0;
                    for(var td=end[1];td>=begin[1];td--){
                        firstTdWidth+=dom('appMain'+tableNum).thead.find('thead th').eq(td-1).outerWidth();
                        if(tr==begin[0] && td==begin[1]){

                        }else{
                            dom('appMain'+tableNum).td(getCellTemp2(tr,td)).dom.hide();
                        }
                    }
                }
            }
        }
        td.config.params.tableId.select = {
        };
        for(var tableNum=0;tableNum<allFileData.length;tableNum++){
            var tableObj = allFileData[tableNum];
            var tableTitle = tableObj.title;
            $('.allTableSelect').append('<li class="'+(tableNum==0?'active':'')+'"><a href="#table_'+tableNum+'" data-toggle="tab">'+tableTitle+'</a></li>');
            td.config.params.tableId.select[tableNum.toString()] = tableTitle;
            tdData[tableNum] = {
                tableTitle:tableTitle,
                tableData:tableObj.tableValue,
                mergeCells:tableObj.mergeCells,
            };
            var tableItemDom = $('<div class="tab-pane fade '+(tableNum==0?'in active':'')+'" data-tableid="'+tableNum+'" id="table_'+tableNum+'"></div>');
            $('#myTabContent').append(tableItemDom);
            var tableDom = tableItemDom;
            //获取宽高
            var hang = 0;
            var lie = 0;
            for(var i in tdData[tableNum].tableData){
                try{
                    var tdPos = getCellTemp(i);
                }catch (e){
                    continue;
                }
                hang = Math.max(hang,tdPos[0]);
                lie = Math.max(lie,tdPos[1]);
            }
            lie = Math.max(lie,6);//至少补充到6列

            alldoms['appMain'+tableNum] = new tableClass(tableNum,hang,lie,tableDom);
            alldoms['appMain'+tableNum].render();
            (function(){
                //单元格列宽
                var nod = document.createElement("style");
                nod.type="text/css";
                $(nod).attr('td_css_list',1);
                var str = "";
                var column = tableObj.column;
                for(var i in column){
                    var thNum = getCellTemp(i+'1')[1];
                    {literal}
                    var strItem = "#myTabContent>.tab-pane:nth-child("+(tableNum+1)+") [lie=\""+thNum+"\"],#myTabContent>.tab-pane:nth-child("+(tableNum+1)+") [lienum=\""+i+"\"]{\n";
                    strItem+='width:'+column[i].width*10+'px;\n';
                    strItem += "}\n";
                    {/literal}
                    str += strItem;
                }
                if(nod.styleSheet){ //ie下
                    nod.styleSheet.cssText = str;
                } else {
                    nod.innerHTML = str;
                }
                document.getElementsByTagName("head")[0].appendChild(nod);
            })();

            var row = tableObj.row;
            for(var i in row){
                var height = row[i].height*1.5;
                $('.tableRow table tr').eq(i-1).find('td').height(height);
                alldoms['appMain'+tableNum].table.find('tbody tr').eq(i-1).find('td:eq(0)').height(height);
            }
            //单元格合并
            initMerge(tableNum,tdData[tableNum].mergeCells);

            //绘制图表
            allEcharts[tableNum] = [];
            if(tableObj.charts!=undefined){
                for(var chartsId = 0;chartsId<tableObj.charts.length;chartsId++){
                    var position = tableObj.charts[chartsId].position.split(',');
                    var size = tableObj.charts[chartsId].size.split(',');
                    if(tableObj.charts[chartsId].value==null){
                        continue;
                    }else{
                        var chartsItem = getEvalObj(tableNum,tableObj.charts[chartsId].value,true);
                    }
                    $('.allCharts:eq('+tableNum+')').append(chartsItem.dom);
                    chartsItem.myChart = echartsObj.init(chartsItem.dom.find('>div')[0],'macarons');
                    chartsItem.top = parseInt(position[0]);
                    chartsItem.left = parseInt(position[1]);
                    chartsItem.width = parseInt(size[0]);
                    chartsItem.height = parseInt(size[1]);
                    chartsItem.dom.attr('index',chartsId);
                    chartsItem.index = chartsId;
                    readyObj.bind(chartsItem);
                    allEcharts[tableNum][chartsId] = chartsItem;

                }
            }
        }
        for(var tableNum=0;tableNum<allFileData.length;tableNum++){
            for(var i in tdData[tableNum].tableData){
                writeTd(tableNum,i,tdData[tableNum].tableData[i].value,tdData[tableNum].tableData[i].xfIndex);
            }
        }

        //修改列宽度
        $('.table>thead>tr>.lieNum>div').each(function(){
            $(this).dragging({
                move: 'x',xLimit:false,yLimit:false,randomPosition: false,onMousemove:function(dom,pos){
                    var tableId = dom.parents('[data-tableid]').data('tableid');
                    var thNum = getCellTemp(dom.parent().attr('lienum')+'1')[1];
                    setTdWidth(tableId,thNum, (pos.left+5)/10);
//                    initMerge(tableId,tdData[1].mergeCells);
                },onMouseup:function(dom){
                    var tableId = dom.parents('[data-tableid]').data('tableid');
                    var lienum = dom.parent().attr('lienum');
                    var width = dom.parent().width();
                    $.post('/action/table.html',{
                        function:'updateWidth',
                        fileId:fileId,
                        tableNum:tableId,
                        lienum:lienum,
                        width:(width/10).toFixed(1)
                    },function(data){
                        console.log(data);
                    });
                }
            });
        });
        //触发表格完成
        readyObj.set(1);
    }
</script>
<script>
    //拖动选择dom
    var isSelectDoms = false;
    var beginSelect = [];
    $('body').on('mousedown','.edit #myTabContent td',function(e){
        e.preventDefault();
    });
    $('body').on('mousedown','.edit #myTabContent td',function(e){
        beginSelect = [$(this).attr('hang'),$(this).attr('lie')];
        isSelectDoms = true;
    });
    $('body').on('mouseenter','.edit #myTabContent td',function(e){
        if(isSelectDoms){
            $('body .edit td').removeClass('editTd');
            $('body .edit td').removeClass('editTdtop');
            $('body .edit td').removeClass('editTdbottom');
            $('body .edit td').removeClass('editTdleft');
            $('body .edit td').removeClass('editTdright');
            var top = Math.min($(this).attr('hang'),beginSelect[0]);
            var bottom = Math.max($(this).attr('hang'),beginSelect[0]);
            var left = Math.min($(this).attr('lie'),beginSelect[1]);
            var right = Math.max($(this).attr('lie'),beginSelect[1]);
            var tableid = $('body #myTabContent .active').data('tableid');
            for(var i=top;i<=bottom;i++){
                for(var j=left;j<=right;j++){
                    if(i==top){
                        dom('appMain'+tableid).td(getCellTemp2(i,j)).dom.addClass('editTdtop');
                    }
                    if(i==bottom){
                        dom('appMain'+tableid).td(getCellTemp2(i,j)).dom.addClass('editTdbottom');
                    }
                    if(j==left){
                        dom('appMain'+tableid).td(getCellTemp2(i,j)).dom.addClass('editTdleft');
                    }
                    if(j==right){
                        dom('appMain'+tableid).td(getCellTemp2(i,j)).dom.addClass('editTdright');
                    }
                    dom('appMain'+tableid).td(getCellTemp2(i,j)).dom.addClass('editTd');
                }
            }
            selectTd(top,right,bottom,left);
        }
    });
    $('body').on('mouseup','.edit #myTabContent td',function(e){
        isSelectDoms = false;
    });

    function setTdSelectState(){
        $('body .edit td').removeClass('editTd');
        $('body .edit td').removeClass('editTdtop');
        $('body .edit td').removeClass('editTdbottom');
        $('body .edit td').removeClass('editTdleft');
        $('body .edit td').removeClass('editTdright');
        $(this).addClass('editTd');
        $(this).addClass('editTdtop');
        $(this).addClass('editTdbottom');
        $(this).addClass('editTdleft');
        $(this).addClass('editTdright');
    }
    $('body').click(function(){
        if($('.floatSingleValueWrite .input input[pos]').length>0){
            $('.floatSingleValueWrite .input input[pos]').each(function(){
                var inputDom = this;
                function afterUpdate(){
                    writeTd($(inputDom).attr('tableid'),
                            $(inputDom).attr('pos'),
                            $(inputDom).val(),
                            $(inputDom).attr('cell_xf'));
                    $(inputDom).removeAttr('tableid');
                    $(inputDom).removeAttr('pos');
                    $(inputDom).removeAttr('cell_xf');
                    $(inputDom).parent().hide();
                    $(inputDom).val('');
                }
                if($(this).attr('oldValue')!=$(this).val()){
                    $.post('/action/table.html',{
                        function:'updateTdValue',
                        fileId:fileId,
                        tableNum:$(this).attr('tableid'),
                        pos:$(this).attr('pos'),
                        value:$(this).val()
                    },function(data){
                        if(data!=='-1'){
                            if(getCellTemp($(inputDom).attr('pos'))[0]>alldoms['appMain'+$(inputDom).attr('tableid')].hang){
                                alldoms['appMain'+$(inputDom).attr('tableid')].addHang();
                            }
                            afterUpdate();
                        }else{
                            alert('样式服务器同步失败');
                        }
                    });
                }else{
                    afterUpdate();
                }
            });
        }
    });
    $('body').on('click','.edit #myTabContent td',function(){
        if(!$(this).is('.idNum')){
            setTdSelectState.call(this);
            selectTd.call(this);
        }
    });
    function initFloatDom(){
        setTdSelectState.call(this);
        //看看当前单元格是否有合并
        var activeId = $('#myTabContent .active').data('tableid');
        $('.table tbody .idNum').removeClass('idNumOn');
        $('.table tbody .idNum').eq(parseInt($(this).attr('hang'))-1).addClass('idNumOn');
        $('.table thead .lieNum').removeClass('lieNumOn');
        $('.table thead .lieNum').eq(parseInt($(this).attr('lie'))-1).addClass('lieNumOn');
        var selectPos = getCellTemp2(parseInt($(this).attr('hang')),parseInt($(this).attr('lie')));
        $('#dataFloat .head').html(selectPos);
        $('#dataFloat .head').attr('action_type','td');
        var thisTdData = tdData[activeId].tableData[selectPos];
        $('#dataFloat').show();
        if(thisTdData==undefined){
            thisTdData = {
                'value':'',
                xfIndex:0,
            };
        }
        if(allTD['td:'+activeId+'!'+selectPos]){
            var tempValue = allTD['td:'+activeId+'!'+selectPos].value_;
        }else{
            var tempValue = '';
        }
        initFloatType(tempValue,$('#dataFloat .content'));
        $('#dataFloat').attr('xfIndex',thisTdData.xfIndex);
        $('#dataFloat').removeClass('floatSingleValue');
    }
    $('body').on('dblclick','.edit #myTabContent .allCharts>div',function(){
        var type = $(this).attr('type');
        var tableId = $('#myTabContent .active').data('tableid');
        var chartsIndex = $(this).attr('index');
        $('#dataFloat').show();
        $('#dataFloat .head').html('图表');

        var allChartsName = [];
        for(var i=0;i<allChartFunction.length;i++){
            allChartsName.push(allChartFunction[i].funcName);
        }
        if(allEcharts[tableId][chartsIndex] instanceof obj && allChartsName.indexOf(allEcharts[tableId][chartsIndex].className)>-1){
            $('#dataFloat .head').attr('action_type','CHARTS');
            $('#dataFloat .head').attr('tableId',tableId);
            $('#dataFloat .head').attr('chartsIndex',chartsIndex);
        }
        initFloatType(allEcharts[tableId][chartsIndex],$('#dataFloat .content'));
    });
    $('body').on('dblclick','.edit #myTabContent td',function(){
        setTdSelectState.call(this);
        //看看当前单元格是否有合并
        var activeId = $('#myTabContent .active').data('tableid');
        var selectPos = getCellTemp2(parseInt($(this).attr('hang')),parseInt($(this).attr('lie')));
        if(allTD['td:'+activeId+'!'+selectPos]){
            var tempValue = allTD['td:'+activeId+'!'+selectPos].value_;
        }else{
            var tempValue = '';
        }
        if(typeof tempValue=='string' || typeof tempValue=='number'){
            //计算宽度
            function getTrueWidth(str,xf){
                var span = $('<span></span>');
                span.attr('cell_xf',xf);
                span.html(str);
                $(this).parents('.tableBody').find('.floatSingleValueWrite .span').html('').append(span);
                return span.width()+8;
            }
            //计算位置
            var tableid = $('body #myTabContent .active').data('tableid');
            $('.tableBody').eq(tableid).scrollTop();
            var position = $(this).position();
            var inputTd = $(this).parents('.tableBody').find('.floatSingleValueWrite .input');
            inputTd.show();
            inputTd.find('input').val(tempValue);
            inputTd.find('input').attr('cell_xf',$(this).attr('cell_xf'));
            inputTd.find('input').attr('tableId',tableid);
            inputTd.find('input').attr('pos',getCellTemp2($(this).attr('hang'),$(this).attr('lie')));
            inputTd.find('input').attr('oldValue',tempValue);
            inputTd.css('left',position.left-parseInt($(this).parents('.tableBody').css('marginLeft'))+$('.tableBody').eq(tableid).scrollLeft()-1);
            inputTd.css('top',position.top-parseInt($(this).parents('.tableBody').css('marginTop'))+$('.tableBody').eq(tableid).scrollTop()-2);
            inputTd.css('height',$(this).outerHeight()+2);
            inputTd.css('min-width',$(this).outerWidth()+1);
            inputTd.css('width',getTrueWidth.call(this,tempValue,$(this).attr('cell_xf')));
            var this_ = this;
            inputTd.find('input').on('input',function() {
                inputTd.css('width',getTrueWidth.call(this_,$(this).val(),$(this_).attr('cell_xf')));
            });
            inputTd.find('input').click(function(event){
                event.stopPropagation();
            });
            inputTd.find('input').focus();
        }else{
            initFloatDom.call(this);
        }
    });
    require.config({
        paths: {
            echarts: 'https://cdn.bootcss.com/echarts/2.2.7'
        }
    });
    var echartsObj;
    require(['echarts','echarts/chart/bar','echarts/chart/line','echarts/chart/pie'],function (ec) {
        echartsObj = ec;
        $.post('/action/table.html',{
            function:'tableInfo',
            fileId:fileId
        },function(data){
            data = JSON.parse(data);
            console.log(data);
            rewriteExcel(data.style,data.data);
            $('#tools .title').html(data.title);
            if(data.isMyTable){
                $('#tools .editChange').show();
                $('.allTableSelect').append('<li class="addTable">&#xe641;</li>');
                isCanEdit = true;
                $('.addTable').click(function(){
                    var name = window.prompt('请输入工作表名称');
                    if(name!=='' && name!=null){
                        $.post('/action/table.html',{
                            function:'tableAdd',
                            fileId:fileId,
                            title:name,
                        },function(data){
                            if(data==-2){
                                alert('工作表名称已存在');
                            }else if(data==1){
                                location.href = location.href;
                            }
                        });
                    }
                });
            }
//                if(data!=='-1'){
//                    if(getCellTemp($(inputDom).attr('pos'))[0]>alldoms['appMain'+$(inputDom).attr('tableid')].hang){
//                        alldoms['appMain'+$(inputDom).attr('tableid')].addHang();
//                    }
//                    afterUpdate();
//                }else{
//                    alert('样式服务器同步失败');
//                }
        });
    });
</script>
{include file="table/dataFloat.mod.tpl"}
{include file="table/wrapper.mod.tpl"}
</body>
</html>