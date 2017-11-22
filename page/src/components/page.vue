<template>
    <div>
        <div id="tablePanel" :class="{edit:isOpenEdit}">
            <tools @stateChange="isOpenEditSet" :title="title" :isMyTable="isMyTable" :isOpenEdit="isOpenEdit"></tools>
            <div id="myTabContentParent">
                <ul class="allTableSelect nav nav-tabs"></ul>
                <div id="myTabContent" class="tab-content"></div>
            </div>
        </div>
        <bottom></bottom>
        <dataFloat></dataFloat>
        <wrapper></wrapper>
    </div>
</template>

<script>
    import bottom from '@/components/bottom.vue'
    import tools from '@/components/tools.vue'
    import dataFloat from '@/components/dataFloat.vue'
    import wrapper from '@/components/wrapper.vue'
    import ajax from '@/tools/ajax.js'
    import Vue from 'vue'
    import echarts from 'echarts'
    import writeTd from '@/tools/writeTd.js';
    import setTdSelectState from '@/tools/setTdSelectState.js';
    import selectTd from '@/tools/selectTd.js';
    echartsObj = echarts;

//    import obj from '@/tools/obj.js'
//    var a = new obj();
//    var b = new obj();
//    b.value = 'i\'m b';
//    console.log("====1======");
//    a.value = b;// = 100;
//    console.log("====2======");
//    b.value = 111;// = 100;
//    console.log("====3======");

    function createCss(i,item){
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
        }
    function rewriteExcel(styleList,dataList){
        window.getCellXfCollection = styleList;
        //单元格样式
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
                    var strItem = "#myTabContent>.tab-pane:nth-child("+(tableNum+1)+") [lie=\""+thNum+"\"],#myTabContent>.tab-pane:nth-child("+(tableNum+1)+") [lienum=\""+i+"\"]{\n";
                    strItem+='width:'+column[i].width*10+'px;\n';
                    strItem += "}\n";
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
                    ajax({
                        url: 'http://www.tablehub.cn/action/table.html',
                        type: 'POST',
                        'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8',
                        data: {
                            function:'updateWidth',
                            fileId:fileId,
                            tableNum:tableId,
                            lienum:lienum,
                            width:(width/10).toFixed(1)
                        },
                        success: function (data) {
                            console.log(data);
                        }
                    });
                }
            });
        });
        //触发表格完成
        readyObj.set(1);
    }
    export default {
        name: 'page',
        methods:{
            isOpenEditSet(state){
                this.isOpenEdit = state;
            }
        },
        data:function(){
            return {
                title:'标题222',
                isMyTable:true,
                isOpenEdit:false,
            }
        },
        components: {
            bottom,tools,dataFloat,wrapper
        },
        created(){
            var this_ = this;
            ajax({
                url: 'http://www.tablehub.cn/action/table.html',
                type: 'POST',
                'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8',
                data: {
                    function: 'tableInfo',
                    fileId: 35,
                    temp:1,
                },
                success: function (data) {
                    this_.title = data.title;
                    this_.isMyTable = data.isMyTable;
                    console.log(data);

                    rewriteExcel(data.style,data.data);
                    if(data.isMyTable){
                        $('#tools .editChange').show();
                        $('.allTableSelect').append('<li class="addTable">&#xe641;</li>');
                        isCanEdit = true;
                        $('.addTable').click(function(){
                            var name = window.prompt('请输入工作表名称');
                            if(name!=='' && name!=null){
                                ajax({
                                    url: 'http://www.tablehub.cn/action/table.html',
                                    type: 'POST',
                                    'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8',
                                    data: {
                                        function:'tableAdd',
                                        fileId:fileId,
                                        title:name,
                                    },
                                    success: function (data) {
                                        if(data==-2){
                                            alert('工作表名称已存在');
                                        }else if(data==1){
                                            location.href = location.href;
                                        }
                                    }
                                });
                            }
                        });
                    }

                }
            });
        }
    }
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
            selectTd.call(window,top,right,bottom,left);
        }
    });
    $('body').on('mouseup','.edit #myTabContent td',function(e){
        isSelectDoms = false;
    });


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
                    ajax({
                        url: 'http://www.tablehub.cn/action/table.html',
                        type: 'POST',
                        'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8',
                        data: {
                            function:'updateTdValue',
                            fileId:fileId,
                            tableNum:$(this).attr('tableid'),
                            pos:$(this).attr('pos'),
                            value:$(this).val()
                        },
                        success: function (data) {
                            if(data!=='-1'){
                                if(getCellTemp($(inputDom).attr('pos'))[0]>alldoms['appMain'+$(inputDom).attr('tableid')].hang){
                                    alldoms['appMain'+$(inputDom).attr('tableid')].addHang();
                                }
                                afterUpdate();
                            }else{
                                alert('样式服务器同步失败');
                            }
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
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
    body{
        background-color: #e6e6e6;
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
