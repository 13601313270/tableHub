<style>
    @font-face {
        font-family: 'iconfont';  /* project id 384848 */
        src: url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.eot');
        src: url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.eot?#iefix') format('embedded-opentype'),
        url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.woff') format('woff'),
        url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.ttf') format('truetype'),
        url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.svg#iconfont') format('svg');
    }
    .edit #tools{
        display: block;
    }
    #tools .editChange{
        width: 55px;height: 20px;margin-top:6px;background-size: 100% 100%!important;float: left;display: none;
    }
    #tools .openEdit{
        border-bottom: 1px solid #ddd;padding-bottom: 0;margin-bottom: 10px;
    }
    #tools .openEdit .editChange{
        background: url(https://n4-q.mafengwo.net/s10/M00/18/A2/wKgBZ1jc3R6AYhi_AAB-2Jyz1WU027.png);
    }
    #tools .closeEdit .editChange{
        background: url(https://c2-q.mafengwo.net/s10/M00/18/1D/wKgBZ1jc3A-AKDulAABm0wptOh4037.png);
    }
    #tools .title{
        margin-left: 10px;float: left;margin-top:6px;
    }
    #tools .toolsContent{
        display: none;padding: 0 5px;height:34px;overflow: hidden;
    }
    #tools .toolsContent .tab-content{
        overflow-x: auto;
    }
    .edit #tools .toolsContent{
        display: block;
    }
    .nav-tabs{
        border-bottom:1px solid #d4d4d4;
    }
    #tools .container .nav-tabs>li>a{
        padding: 5px 6px;
    }
    #tools .container .nav-tabs{
        display: none;float: left;margin-left: 20px;border: none;
    }
    #tools .openEdit .nav-tabs{
        display: block;
    }
    #tools .tab-pane{
        height:34px;font-family: iconfont;
    }
    .edit #myTabContentParent .tab-pane{
        padding-top: 1px;
    }
    #myTabContentParent{
        position:fixed;top:45px;left:0;right:0;bottom:20px;
    }
    .edit #myTabContentParent{
        top:90px;
    }
    .tableRow td{
        height:22px;
    }
</style>
<script>
    function selectTd(){
        if($(this).attr('cell_xf')==undefined){
            $('.toolsContent [data-name=color]').css('color','');
            $('.toolsContent [data-name=bold]').removeClass('active');
            $('.toolsContent [data-name=size]').val('');
            $('.toolsContent [data-name=underline]').removeClass('active');
            $('.toolsContent [data-name=italic]').removeClass('active');
            $('.toolsContent [data-name=fill]').css('backgroundColor','white');
            $('.toolsContent [data-name=tdMerge]').removeClass('active');
        }else{
            var cell_xf = getCellXfCollection[$(this).attr('cell_xf')];
            if(cell_xf.font){
                if(cell_xf.font.color){
                    $('.toolsContent [data-name=color]').css('color','#'+cell_xf.font.color.slice(2));
                }
                if(cell_xf.font.bold===1){
                    $('.toolsContent [data-name=bold]').addClass('active');
                }else{
                    $('.toolsContent [data-name=bold]').removeClass('active');
                }
                if(cell_xf.font.size){
                    $('.toolsContent [data-name=size]').val(cell_xf.font.size);
                }
                if(cell_xf.font.underline==='single'){
                    $('.toolsContent [data-name=underline]').addClass('active');
                }else{
                    $('.toolsContent [data-name=underline]').removeClass('active');
                }
                if(cell_xf.font.italic===1){
                    $('.toolsContent [data-name=italic]').addClass('active');
                }else{
                    $('.toolsContent [data-name=italic]').removeClass('active');
                }
            }
            if(cell_xf.fill && cell_xf.fill.fillType!=='none'){
                $('.toolsContent [data-name=fill]').css('backgroundColor','#'+cell_xf.fill.startColor.slice(2));
            }
            else{
                $('.toolsContent [data-name=fill]').css('backgroundColor','white');
            }
            if(cell_xf.alignment){
                $('.toolsContent [data-name=horizontal_left]').removeClass('active');
                $('.toolsContent [data-name=horizontal_center]').removeClass('active');
                $('.toolsContent [data-name=horizontal_right]').removeClass('active');
                if(cell_xf.alignment.horizontal=='left'){
                    $('.toolsContent [data-name=horizontal_left]').addClass('active');
                }else if(cell_xf.alignment.horizontal=='center'){
                    $('.toolsContent [data-name=horizontal_center]').addClass('active');
                }else if(cell_xf.alignment.horizontal=='right'){
                    $('.toolsContent [data-name=horizontal_right]').addClass('active');
                }else if(cell_xf.alignment.horizontal=='general'){
                }
            }
        }
        if(this!==window && !$(this).is('.mergeTd')){
            $('.toolsContent [data-name=tdMerge]').removeClass('active');
            $('.toolsContent [data-name=tdMerge]').addClass('disabled');
        }else{
            var isHasMerge = false;
            var activeId = $('#myTabContent .active').data('tableid');
            for(var i in tdData[activeId].mergeCells){
                if(i.split(":")[0] == getCellTemp2($(this).attr('hang'),$(this).attr('lie'))){
                    isHasMerge = true;break;
                }
            }
            if(isHasMerge){
                $('.toolsContent [data-name=tdMerge]').addClass('active');
            }else{
                $('.toolsContent [data-name=tdMerge]').removeClass('active');
            }
            $('.toolsContent [data-name=tdMerge]').removeClass('disabled');
        }
    }
//    $('#tdAction [data-action=merge]').click(function(){
//        if($(this).is('.use')){
//            var leftTop = $('.editTdtop').filter('.editTdleft');
//            var leftTopExcelPos = getCellTemp2(leftTop.attr('hang'),leftTop.attr('lie'));
//        }else{
//            var leftTop = $('.editTdtop').filter('.editTdleft');
//            var leftTopExcelPos = getCellTemp2(leftTop.attr('hang'),leftTop.attr('lie'));
//            var rightBottom = $('.editTdbottom').filter('.editTdright');
//            var rightBottomExcelPos = getCellTemp2(rightBottom.attr('hang'),rightBottom.attr('lie'));
//        }
//    });
</script>
<div id="tools">
    <div class="container closeEdit">
        <div class="editChange"></div>
        <div class="title"></div>
        <ul class="nav nav-tabs">
            <li class="active"><a href="#tool1" data-toggle="tab">开始</a></li>
            <li><a href="#tool2" data-toggle="tab">图表</a></li>
            <li><a href="#tool3" data-toggle="tab">分析</a></li>
        </ul>
    </div>
    <div class="toolsContent">
        <div class="tab-content">
            <div class="tab-pane fade in active" id="tool1" style="width: 812px;">
                <div class="btn-group">
                    <button class="btn btn-default" data-name="bold">&#xe63f;</button>
                    <button class="btn btn-default" data-name="italic">&#xe60d;</button>
                    <button class="btn btn-default" data-name="underline">&#xe614;</button>
                </div>
                <div class="btn-group">
                    <button type="button" class="btn btn-default" data-name="horizontal_left"><span class="glyphicon glyphicon-align-left" aria-hidden="true"></span></button>
                    <button type="button" class="btn btn-default" data-name="horizontal_center"><span class="glyphicon glyphicon-align-center" aria-hidden="true"></span></button>
                    <button type="button" class="btn btn-default" data-name="horizontal_right"><span class="glyphicon glyphicon-align-right" aria-hidden="true"></span></button>
                </div>
                <div class="btn-group">
                    <button type="button" class="btn btn-default" data-name="tdMerge">&#xe60f;</button>
                </div>
                <div class="btn-group">
                    <div class="input-group" style="width: 110px;">
                        <div class="input-group-addon">&#xe715;</div>
                        <input type="number" class="form-control" data-name="size" placeholder="字号">
                    </div>
                </div>
                <div class="btn-group">
                    <button type="button" class="btn btn-default" data-name="fill">&#xe690;</button>
                    <button type="button" class="btn btn-default" data-name="color">&#xe613;</button>
                </div>
                <div class="btn-group">
                    <button type="button" class="btn btn-default" data-name="fx">&#xe646;</button>
                </div>
                <div class="btn-group" style="display: none">
                    <div class="input-group disabled" style="width: 150px;">
                        <div class="input-group-addon">输出格式</div>
                        <select class="form-control disabled" style="appearance: none;-moz-appearance: none;-webkit-appearance: none;background:url(http://ourjs.github.io/static/2015/arrow.png) no-repeat scroll right center rgb(255, 255, 255);">
                            <option>无</option>
                            <option>美元</option>
                            <option>人民币</option>
                        </select>
                    </div>
                </div>
                <div class="btn-group" style="display: none">
                    <label class="checkbox-inline">
                        <input type="checkbox disabled" id="inlineCheckbox1" value="option1">网格线
                    </label>
                    <label class="checkbox-inline">
                        <input type="checkbox disabled" id="inlineCheckbox1" value="option1">标题
                    </label>
                </div>
            </div>
            <div class="tab-pane fade" id="tool2" style="width: 783px;">
                <div class="btn-group">
                    <button type="button" class="insertBar btn btn-default">&#xe600;柱状图</button>
                    {*<button type="button" class="btn btn-default">&#xe610;堆积柱状图</button>*}
                    {*<button type="button" class="btn btn-default">&#xe611;簇形柱状图</button>*}
                </div>
                <div class="btn-group">
                    <button type="button" class="insertLine btn btn-default">&#xe636;折线图</button>
                    {*<button type="button" class="btn btn-default">&#xe62b;标记折线图</button>*}
                    {*<button type="button" class="btn btn-default">&#xe61e;面积折线图</button>*}
                </div>
                <div class="btn-group">
                    <button type="button" class="insertPie btn btn-default">&#xe60c;饼状图</button>
                </div>
                {*<div class="btn-group">*}
                    {*<button type="button" class="btn btn-default">&#xe63a;散点图</button>*}
                {*</div>*}
            </div>
            <div class="tab-pane fade" id="tool3">3</div>
        </div>
    </div>
</div>
<script>
    function rewriteStyle(){
        if($(this).is('.disabled')){
            return;
        }
        if($(this).is('[data-name=fill]')){
            return;
        }
        if($(this).is('[data-name=fx]')){
            return;
        }
        var actionType = $(this).data('name');
        var isActive = $(this).is('.active');
        var value = $(this).val();
//        console.log(this);
        var this_ = $('.editTd');
        if(this_.length==0){
            return;
        }
        var cell_xf = $(this_).attr('cell_xf');
        var pos = getCellTemp2($(this_).attr('hang'),$(this_).attr('lie'));
        function run(){
            var isExist = false;//是否已经存在一个这样样式的id
            var isExistId = -1;
            for(var i=0;i<getCellXfCollection.length;i++){
                if(JSON.stringify(getCellXfCollection[i])==JSON.stringify(cell_xf) ){
                    isExistId = i;
                    isExist = true;break;
                }
            }
            if(isExist){
                if(parseInt($(this_).attr('cell_xf'))!==isExistId){
                    $.post('/action/table.html',{
                        function:'updateTdXf',
                        fileId:fileId,
                        tableNum:$('#myTabContent .active').data('tableid'),
                        pos:pos,
                        xfIndex:isExistId,
                    },function(data){
                        if(data!=='-1'){
                            $(this_).attr('cell_xf',data);
                        }else{
                            alert('样式服务器同步失败');
                        }
                    });
                }
            }
            else{
                $.post('/action/table.html',{
                    function:'updateTdXf',
                    fileId:fileId,
                    tableNum:$('#myTabContent .active').data('tableid'),
                    pos:pos,
                    value:cell_xf,
                },function(data){
                    var cssstr = createCss(data,cell_xf);
                    $('style[td_css_list]').append(cssstr);
                    $(this_).attr('cell_xf',data);
                    getCellXfCollection[data] = cell_xf;
                });
            }
        }
        if(cell_xf!==undefined){
            cell_xf = JSON.parse(JSON.stringify(getCellXfCollection[cell_xf]));//clone成一个新对象
        }
        if(['bold','italic'].indexOf(actionType)>-1){
            if(isActive){
                $('.toolsContent [data-name='+actionType+']').removeClass('active');
            }else{
                $('.toolsContent [data-name='+actionType+']').addClass('active');
            }
            cell_xf.font[actionType] = (!isActive)?1:0;
        }else if(actionType=='underline'){
            if(isActive){
                $('.toolsContent [data-name='+actionType+']').removeClass('active');
                cell_xf.font[actionType] = 'none';
            }else{
                $('.toolsContent [data-name='+actionType+']').addClass('active');
                cell_xf.font[actionType] = 'single';
            }
        }else if(['horizontal_left','horizontal_center','horizontal_right'].indexOf(actionType)>-1){
            $('.toolsContent [data-name=horizontal_left]').removeClass('active');
            $('.toolsContent [data-name=horizontal_center]').removeClass('active');
            $('.toolsContent [data-name=horizontal_right]').removeClass('active');
            $('.toolsContent [data-name='+actionType+']').addClass('active');
            if(actionType==='horizontal_left'){
                cell_xf.alignment.horizontal = 'left';
            }else if(actionType==='horizontal_center'){
                cell_xf.alignment.horizontal = 'center';
            }else if(actionType==='horizontal_right'){
                cell_xf.alignment.horizontal = 'right';
            }
        }else if(actionType=='size'){
            cell_xf.font.size = parseInt(value);
        }else if(actionType=='tdMerge'){
            if(isActive){
                $('.toolsContent [data-name='+actionType+']').removeClass('active');
                var lie = $(this_).attr('lie');
                var colspan = $(this_).attr('colspan');

                var hang = $(this_).attr('hang');
                var rowspan = $(this_).attr('rowspan');
                $.post('/action/table.html',{
                    function:'mergeCancel',
                    fileId:fileId,
                    tableNum:$('#myTabContent .active').data('tableid'),
                    pos:pos
                },function(data){
                    if(data!=='-1'){
                        $(this_).attr('colspan','');
                        $(this_).attr('rowspan','');
                        var tableDom = alldoms['appMain'+$('body #myTabContent .active').data('tableid')].table;
                        for(var i=hang;i<hang+rowspan;i++){
                            var hangTr = tableDom.find('tr[hang='+i+']');
                            for(var j=lie;j<lie+colspan;j++){
                                hangTr.find('[lie='+j+']').show();
                            }
                        }
                    }else{
                        alert('样式服务器同步失败');
                    }
                });
            }else{
                var top = $('.editTdtop').attr('hang');
                var bottom = $('.editTdbottom').attr('hang');
                var left = $('.editTdleft').attr('lie');
                var right = $('.editTdright').attr('lie');
                $.post('/action/table.html',{
                    function:'mergeAdd',
                    fileId:fileId,
                    tableNum:$('#myTabContent .active').data('tableid'),
                    top:top,
                    bottom:bottom,
                    left:left,
                    right:right,
                },function(data){
                    if(data!=='-1'){
                        $(this_).css('display','none');
                        $(this_).eq(0).show();
                        $(this_).eq(0).attr('rowspan',bottom-top+1);
                        $(this_).eq(0).attr('colspan',right-left+1);
                        var mergeStr  =getCellTemp2(top,left)+":"+getCellTemp2(bottom,right);
                        console.log(mergeStr);
                        tdData[$('#myTabContent .active').data('tableid')].mergeCells[mergeStr] = mergeStr;
                        $('.toolsContent [data-name='+actionType+']').addClass('active');
                    }else{
                        alert('样式服务器同步失败');
                    }
                });
            }
            return;
        }
        run();
        console.log(  cell_xf  );
    }
    $('#tools .toolsContent [data-name]button').click(rewriteStyle);
    $('#tools .toolsContent [data-name=size]').change(rewriteStyle);
    $("[data-name=fill],[data-name=color]").spectrum({
        showPalette: true,
        hide:function(color){
            var writeTd = $('.editTd');
            if(writeTd.length==0){
                return;
            }
            var cell_xf = $(writeTd).attr('cell_xf');
            var pos = getCellTemp2($(writeTd).attr('hang'),$(writeTd).attr('lie'));
            function run(callBack){
                var isExist = false;//是否已经存在一个这样样式的id
                var isExistId = -1;
                for(var i=0;i<getCellXfCollection.length;i++){
                    if(JSON.stringify(getCellXfCollection[i])==JSON.stringify(cell_xf) ){
                        isExistId = i;
                        isExist = true;break;
                    }
                }
                $(writeTd).attr('cell_xf',80);
                if(isExist){
                    if(parseInt($(writeTd).attr('cell_xf'))!==isExistId){
                        $.post('/action/table.html',{
                            function:'updateTdXf',
                            fileId:fileId,
                            tableNum:$('#myTabContent .active').data('tableid'),
                            pos:pos,
                            xfIndex:isExistId,
                        },function(data){
                            if(data!=='-1'){
                                $(writeTd).attr('cell_xf',data);
                                callBack(data);
                            }else{
                                alert('样式服务器同步失败');
                            }
                        });
                    }
                }
                else{
                    $.post('/action/table.html',{
                        function:'updateTdXf',
                        fileId:fileId,
                        tableNum:$('#myTabContent .active').data('tableid'),
                        pos:pos,
                        value:cell_xf,
                    },function(data){
                        var cssstr = createCss(data,cell_xf);
                        $('style[td_css_list]').append(cssstr);
                        $(writeTd).attr('cell_xf',data);
                        getCellXfCollection[data] = cell_xf;
                        callBack(data);
                    });
                }
            }
            if(cell_xf==undefined){
                cell_xf = 0;
            }
            cell_xf = JSON.parse(JSON.stringify(getCellXfCollection[cell_xf]));//clone成一个新对象
            var button = $(this);
            if(button.is('[data-name=fill]')){
                console.log(cell_xf);
                cell_xf.fill.startColor = 'FF'+color.toHexString().substr(1);
                cell_xf.fill.fillType = 'solid';
                run(function(){
                    console.log(button);
                    console.log(color.toHexString());
                    button.css('background-color',color.toHexString());
                });
            }else{
                cell_xf.font.color = 'FF'+color.toHexString().substr(1);
                run(function(){
                    button.css('color',color.toHexString());
//                    $(writeTd).css('backgroundColor','');
                });
            }
        },
        palette: [
            ["#000","#444","#666","#999","#ccc","#eee","#f3f3f3","#fff"],
            ["#f00","#f90","#ff0","#0f0","#0ff","#00f","#90f","#f0f"],
            ["#f4cccc","#fce5cd","#fff2cc","#d9ead3","#d0e0e3","#cfe2f3","#d9d2e9","#ead1dc"],
            ["#ea9999","#f9cb9c","#ffe599","#b6d7a8","#a2c4c9","#9fc5e8","#b4a7d6","#d5a6bd"],
            ["#e06666","#f6b26b","#ffd966","#93c47d","#76a5af","#6fa8dc","#8e7cc3","#c27ba0"],
            ["#c00","#e69138","#f1c232","#6aa84f","#45818e","#3d85c6","#674ea7","#a64d79"],
            ["#900","#b45f06","#bf9000","#38761d","#134f5c","#0b5394","#351c75","#741b47"],
            ["#600","#783f04","#7f6000","#274e13","#0c343d","#073763","#20124d","#4c1130"]
        ]
    });
    $('[data-name=fx]').click(function(){
        var this_ = $('.editTd');
        if(this_.length!==1){
            return;
        }
        initFloatDom.call($('.editTd')[0]);
    })
    function insertCharts(valueStr){
        var tableNum = parseInt($('#myTabContent>.tab-pane.active').attr('data-tableid'));
        var chartsId = allEcharts[tableNum].length;
        var position = [200,100];
        var size = [300,200];
        var saveVlalue = valueStr;
        $.post('/action/table.html',{
            function:'insertChartsValue',
            fileId:fileId,
            tableNum:tableNum,
            chartsIndex:chartsId,
            value:saveVlalue,
            position:position,
            size:size
        },function(data){
            if(data!=='-1'){
                var chartsItem = getEvalObj(tableNum,saveVlalue,true);
                $('.allCharts:eq(0)').append(chartsItem.dom);
                chartsItem.myChart = echartsObj.init(chartsItem.dom.find('>div')[0],'macarons');
                chartsItem.top = parseInt(position[0]);
                chartsItem.left = parseInt(position[1]);
                chartsItem.width = parseInt(size[0]);
                chartsItem.height = parseInt(size[1]);
                chartsItem.dom.attr('index',chartsId);
                chartsItem.index = chartsId;
                allEcharts[tableNum][chartsId] = chartsItem;
                allEcharts[tableNum][chartsId].render();
                allEcharts[tableNum][chartsId].myChart.resize();
            }else{
                alert('样式服务器同步失败');
            }
        });
    }
    $('.insertPie').click(function(){
        insertCharts('PIE("标题","","")');
    });
    $('.insertBar').click(function(){
        insertCharts('BAR("标题","","")');
    });
    $('.insertLine').click(function(){
        insertCharts('LINE("标题","","")');
    });
</script>