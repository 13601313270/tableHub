<html>
<head>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
    <link href="//cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="//cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
    <script src="//cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="ace/src-min/ace.js" type="text/javascript" charset="utf-8"></script>
    <script src="ace/src/ext-language_tools.js"></script>
    <link href="//at.alicdn.com/t/font_7e1paq1lsivk7qfr.css" rel="stylesheet">
    {*<script src="//cdn.bootcss.com/html2canvas/0.5.0-beta4/html2canvas.min.js"></script>*}
    <script src="//cdn.bootcss.com/html2canvas/0.4.1/html2canvas.js"></script>
</head>
<body>
    <div id="actionProgress" class="progress" style="border-radius: 0;margin-bottom: 5px;">
        <div class="progress-bar progress-bar-success progress-bar-striped active" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%"></div>
    </div>
    <div>
        <ul id="myTab" class="nav nav-tabs" style="padding: 0 5px;">
            <li class="active"><a href="#home" data-toggle="tab">页面</a></li>
            <li><a data-toggle="tab" href="#modAdmin">通用模块</a></li>
            <li><a data-toggle="tab" href="#templateAdmin">通用模板</a></li>
            <li><a data-toggle="tab" href="#templateDataEditor">前端数据</a></li>
        </ul>
        <style>
            #toolTip{
                height:130px;
                border-bottom:1px solid #ddd;
                /*overflow-x: scroll;*/
            }
            #toolTip>.tab-pane>.panel{
                float: left;
                margin: 3px;
                overflow: hidden;
            }
            #toolTip>.tab-pane>.panel>.panel-heading{
                padding: 3px 3px 3px 10px;
            }
            #toolTip>.tab-pane>.panel>.panel-body{
                padding: 3px;
            }
            #toolTip>.tab-pane .input-group{
                margin: 1px;
            }
            #toolTipHide{
                position:absolute;z-index:2;width: 100%;height: 10px;text-align: center;margin-top: -5px;
            }
            #toolTipHide:hover{
                background-color: #c2c2c2;
            }
            #toolTipHide>span{
                margin-top: -3px;
            }
        </style>
        <div id="toolTip" class="tab-content">
            <div class="tab-pane fade in active" id="home" style="width: 908px;">
                <div class="panel panel-default" style="width:170px;">
                    <div class="panel-heading">操作</div>
                    <div class="panel-body">
                        <button class="btn btn-default" onclick="save()">
                            <span class="glyphicon glyphicon-floppy-saved" aria-hidden="true"></span>保存
                        </button>
                        <script>
                            function save(){
                                $.post('',{
                                    action:'save',
                                    tplContent:tplEditor.getValue(),
                                    phpContent:phpEditor.getValue(),
                                    file:'{$file}',
                                },function(data){
                                    console.log(data);
                                });
                            }
                        </script>
                    </div>
                </div>
                <div class="panel panel-default" style="width:360px;">
                    <div class="panel-heading">网址</div>
                    <div class="panel-body">
                        <div class="input-group">
                            <div class="input-group-addon">网址</div>
                            <input class="form-control" placeholder="网址">
                        </div>
                        <div class="input-group">
                            <div class="input-group-addon">php</div>
                            <input class="form-control" placeholder="php">
                        </div>
                    </div>
                </div>
                <div id="mastGet" class="panel panel-default" style="width:360px;">
                    <div class="panel-heading">必填参数</div>
                    <div class="panel-body">
                        {foreach $allGet as $column}
                            <div class="input-group">
                                <div class="input-group-addon">{$column}</div>
                                <input class="form-control" data-id="{$column}" placeholder="{$column}">
                            </div>
                        {/foreach}
                    </div>
                </div>
                <script>
                    function allGet(){
                        var allGet = {
                        };
                        $('#mastGet .panel-body input').each(function(){
                            allGet[$(this).data('id')] = $(this).val();
                        });
                        return allGet;
                    }
                </script>
            </div>
            {include file="pageEditAdmin/modAdmin.block.tpl"}
            <script>
                modAdminBlock.select(function(content){
                    var tabStr = '';
                    var selectRange = tplEditor.getSelectionRange();
                    selectRange.start.row-=2;
                    var preText = tplEditor.session.getTextRange(selectRange);
                    preText = preText.match(/(\n)(\s*).*\n(\s*)$/);
                    if(preText!==null){
                        var preLineTextTab = preText[2];
                        var selectRange = tplEditor.getSelectionRange();
                        selectRange.start.column=0;
                        if( tplEditor.session.getTextRange(selectRange).match(/^\s*$/) ){
                            tplEditor.session.remove(selectRange);
                            tabStr += preLineTextTab;
                        }
                    }
                    tplEditor.insert(tabStr+content);
                });
            </script>
            {include file="pageEditAdmin/templateAdmin.block.tpl"}
            <div class="tab-pane fade" id="templateDataEditor" style="width:100%;height:130px;">前端使用的数据</div>
        </div>
        <div id="toolTipHide">
            <span class="glyphicon glyphicon-chevron-up"></span>
        </div>
        <script>
            $('#toolTipHide').click(function(){
                if($('#leftActionPanel').parent().css('top')=='215px'){
                    $('#toolTipHide').css('top',5);
                    $('#toolTipHide').html('<span class="glyphicon glyphicon-chevron-down"></span>');
                    $('#leftActionPanel').parent().css('top',10);
                    $('#myTab').hide();
                    $('#toolTip').hide();
                }else{
                    $('#toolTipHide').css('top','auto');
                    $('#toolTipHide').html('<span class="glyphicon glyphicon-chevron-up"></span>');
                    $('#leftActionPanel').parent().css('top',215);
                    $('#myTab').show();
                    $('#toolTip').show();
                }
                tplEditor.resize();
            });
        </script>
    </div>
    <style>
        #leftActionPanel{
            width: 50%;height:100%;float: left;position:relative;
        }
        #leftActionPanel>.nav{
            padding: 0 5px;
        }
        #leftActionPanel>.tab-content{
            position:absolute;top:42px;bottom:0;width: 100%;
        }
        #leftActionPanel #tplCode{
            width: 100%;height: 100%;
        }
    </style>
    <div style="position:fixed;bottom:0;top:215px;left:0;right:0;border-bottom: solid 1px #5d5d5d;z-index: 2;background-color: white;">
        <div id="leftActionPanel">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#tplCode" data-toggle="tab">.tpl</a></li>
                <li><a data-toggle="tab" href="#phpCode">.php</a></li>
                <li><a data-toggle="tab" href="#containerAdmin">布局</a></li>
            </ul>
            <div class="tab-content">
                <div id="tplCode" class="tab-pane fade in active">
                    <section id="tplEditor" style="height: 100%;">{htmlspecialchars($tplFileContent)}</section>
                </div>
                <div id="phpCode" class="tab-pane fade">
                    <section id="phpEditor" style="height: 100%;">{htmlspecialchars($phpFileContent)}</section>
                </div>
                <div id="containerAdmin">
                    {include file="pageEditAdmin/containerAdmin.block.tpl"}
                </div>
            </div>
        </div>

        <script>
            function initIframeByHtml(iframeDom,html){
                var htmlList = html.match(/<html>\s*<head>([\S|\s]*)<\/head>\s*<body(\s[^>]*)?>([\S|\s]+)<\/body>\s*<\/html>/);
                if(htmlList[2]!=undefined){
                    var bodyAttr = htmlList[2].split(' ');
                    for(var i=0;i<bodyAttr.length;i++){
                        var key = bodyAttr[i].match(/(\S+)=['|"]([\S|\s]+)['|"]$/);
                        if(key){
                            $($(iframeDom)[0].contentDocument).find('body').attr(key[1],key[2]);
                        }
                    }
                }
                if($($(iframeDom)[0].contentDocument).find('head').html()!=htmlList[1]){
                    $($(iframeDom)[0].contentDocument).find('head').html(htmlList[1]);
                }
                $($(iframeDom)[0].contentDocument).find('body').html(htmlList[3]);
            }

            var templateDataEditor = ace.edit('templateDataEditor');
            templateDataEditor.$blockScrolling = Infinity;
            templateDataEditor.setFontSize(16);
            templateDataEditor.setReadOnly(true);
            templateDataEditor.getSession().setMode('ace/mode/json');
            templateDataEditor.setTheme("ace/theme/twilight");

            function initPushResultHtml(pushResult){
                templateDataEditor.setValue(JSON.stringify(pushResult, undefined, 4));
            }
            function reloadDataAndLastHtml(){
                if(tplEditor.getValue()!==''){
                    $.post('',{
                        action:'runData',
                        tplContent:tplEditor.getValue(),
                        phpContent:phpEditor.getValue(),
                        tplLine:tplEditor.selection.getRange().start,
                        phpLine:phpEditor.selection.getRange().start,
                        onEditor:onEditor,
                        simulate:allGet()
                    },function(data){
                        try{
                            data = JSON.parse(data);
                        }catch(e){
                            {literal}
                            initIframeByHtml($('#tpl'),'<html><head></head><body>'+data+'</body></html>');
                            {/literal}
                            return;
                        }
                        if(data.debug===true){
                            if(data.type=='objectParams'){
                                if(onEditor == 'php'){
                                    allPhpComplate = [];
                                }else{
                                    allTplComplate = [];//搜索结果
                                }
                                for(var i in data.data){
                                    var item = {
                                        name: i,
                                        value: i,//实际输出
                                        dataValue:data.data[i],
                                        caption: (i+'(属性:'+data.data[i]+')'),//搜索浮层展示
//                                        meta: 'function',
                                        type: "local",
                                        score: 1000 // 让test排在最上面
                                    };
                                    if(onEditor == 'php'){
                                        allPhpComplate.push(item);
                                    }else{
                                        allTplComplate.push(item);
                                    }
                                }
                                if(onEditor == 'php'){
                                    phpEditor.completer.showPopup(phpEditor)
                                }else{
                                    tplEditor.completer.showPopup(tplEditor)
                                }
                            }
                        }else{
                            allTplComplate = [];//搜索结果
                            initPushResultHtml(data.pushResult);
                            for(var i in data.pushResult){
                                allTplComplate.push({
                                    name: i,
                                    value: '$'+i,//实际输出
                                    dataValue:data.pushResult[i],
                                    caption: ('$'+i+'(页面数据)'),//搜索浮层展示
//                                    meta: 'function',
                                    type: "local",
                                    score: 1000 // 让test排在最上面
                                });
                            }
                            initIframeByHtml($('#tpl'),data.html);
                        }
                    });
                }else{
                    $($('#tpl')[0].contentDocument).find('head').html('');
                    $($('#tpl')[0].contentDocument).find('body').html('');
                }
            }
            $('#mastGet .panel-body input').on('change',function(){
                var allParams = [];
                $('#mastGet .panel-body input').each(function(){
                    allParams.push($(this).data('id')+'='+$(this).val());
                });
                $('#tpl').attr('src','{$url}?'+allParams.join('&'));
                setTimeout(function(){
                    reloadDataAndLastHtml();
                },500);
            });
            //初始化编辑器
            var lastWriteTime = (new Date()).getTime();//最后一次输入编辑器的时间
            function initEditor(id,language,addCompleter){
                var languageTools = ace.require("ace/ext/language_tools");
                window[id] = ace.edit(id);
                window[id].$blockScrolling = Infinity;
                window[id].setFontSize(16);
//            window[id].getSession().setMode("ace/mode/html");
                window[id].getSession().setMode(language);
                window[id].setTheme("ace/theme/twilight");
                window[id].setOptions({
                    enableBasicAutocompletion: true,
                    enableSnippets: true,
                    enableLiveAutocompletion: true
                });
                {literal}
                    window[id].getSession().on('change', function(e) {
                        lastWriteTime = (new Date()).getTime();
                        if(e.action=='insert'){
                        }else{
                        }
                        var timeLimit = 200;
                        $('#tpl').css('opacity',0.2);
                        window.setTimeout(function(){
                            if((new Date()).getTime()-lastWriteTime>timeLimit*0.9){
                                reloadDataAndLastHtml();
                                $('#tpl').css('opacity',1);
                            }
                        },timeLimit);
                        return 'asfasdf';
                    });
                {/literal}
                if(addCompleter!==undefined){
//                    languageTools.setCompleters(addCompleter);
                    languageTools.addCompleter(addCompleter);
                }
            }
            var allTplComplate = [];
            var allPhpComplate = [];
            {literal}
            //所有自动填充
            var allAutoEndStr = [
                ['if',' $0}\n{/if}'],
                ['foreach',' $0 as }\n{/foreach}'],
            ];
            initEditor('tplEditor','ace/mode/smarty',{
                getCompletions: function (tplEditor, session, pos, prefix, callback) {
//                    console.log(this.getTagCompletions);
                    if(onEditor=='tpl'){
                        for(var i=0;i<allAutoEndStr.length;i++){
                            allTplComplate.push({
                                name: allAutoEndStr[i][0],
                                value: allAutoEndStr[i][0],//实际输出
                                snippet: allAutoEndStr[i][0] + allAutoEndStr[i][1],
                                caption: allAutoEndStr[i][0],//搜索浮层展示
//                        meta: 'function',
                                type: "tag",
                                close:'<end>',
                                score: 100 // 让test排在最上面
                            });
                        }
                        callback(null,allTplComplate);
                    }else{
                        callback(null,allPhpComplate);
                    }
                },
                getDocTooltip:function(data){
//                    for(var i=0;i<allTplComplate.length;i++){
//                        return data.value
//                        return '<div>afsadfads</div>';
//                    }
                    if(data.dataValue instanceof Array){
                        var returnHtml = "数组[\n";
                        for(var i in data.dataValue){
                            returnHtml += "\t"+data.dataValue[i].toString().substr(0,20)+",\n";
                        }
                        returnHtml += "]";
                        return returnHtml;
                    }else if(data.dataValue instanceof Object){
                        var returnHtml = "对象{\n";
                        for(var i in data.dataValue){
                            returnHtml += "\t"+i+':'+data.dataValue[i].toString().substr(0,20)+"\n";
                        }
                        returnHtml += "}";
                        return returnHtml;
                    }else{
                        if(data.dataValue!==undefined){
                            return data.dataValue;
                        }
                    }
//                    callback('<div>afsadfads</div>');

                }
            });//"ace/mode/smarty"  "ace/mode/html"  "ace/mode/php"
            setTimeout(function(){
                tplEditor.getSession().getMode().$behaviour.add("smartyAutoclosing", "insertion", function (state, action, editor, session, text) {
                    if (text == '}') {
                        var position = editor.getSelectionRange().start;
                        var thisLineText = tplEditor.getValue().split("\n")[position.row].substr(0,position.column);
                        var typeName = thisLineText.match(/\{([^\{|\s|\/][^\{|\s]+)([^\}]*)$/);
                        if(typeName!==null && ['if','foreach'].indexOf(typeName[1])>-1){
                            if(typeName[2]==''){
                                return {
                                    text: " }\n" + thisLineText.match(/^\s*/)[0]+"{/" + typeName[1] + "}",
                                    selection: [1, 1]
                                };
                            }else{
                                return {
                                    text: "}\n" + thisLineText.match(/^\s*/)[0]+"{/" + typeName[1] + "}",
                                    selection: [1, 1]
                                };
                            }
                        }
                    }
                });
            },5000);
            {/literal}
            initEditor('phpEditor','ace/mode/php');
            //监听光标改动事件
            var onEditor = 'tpl';//当前正在的
            tplEditor.selection.on('changeSelection',function(){
                onEditor = 'tpl';
//                console.log(tplEditor.selection.getRange());
            });

            phpEditor.selection.on('changeSelection',function(){
                onEditor = 'php';
//                console.log(tplEditor.selection.getRange());
            });


//            editor.on("changeSelection", this.changeListener);
//            editor.on("blur", this.blurListener);
//            editor.on("mousedown", this.mousedownListener);
//            editor.on("mousewheel", this.mousewheelListener);
        </script>
        <section id="pageShow" style="width: 50%;height:100%;float: left;position: relative;overflow: hidden;">
            <!--宽度调节器-->
            <style>
                #split{
                    width: 10px;top:0;left:0px;height:100%;position:absolute;background-color: black;opacity: 0;cursor: ew-resize;
                }
                #split:hover{
                    opacity: 0.1;
                }
            </style>
            <div id="split"></div>
            <script>
                //控制左右两侧的dom宽度
                function initLeftAndRightWidth(leftWidth){
                    leftWidth = (leftWidth / document.documentElement.clientWidth * 100).toFixed(2);
                    var allWidth = document.documentElement.clientWidth;//总宽度
                    var leftMinWidth = 100;
                    var rightMinWidth = 200;
                    if(leftWidth/100*allWidth<leftMinWidth){
                        leftWidth = leftMinWidth/allWidth*100;
                    }
                    if(leftWidth/100*allWidth>allWidth-rightMinWidth){
                        leftWidth = (allWidth-rightMinWidth)/allWidth*100;
                    }
                    $('#leftActionPanel').width(leftWidth + '%');
                    $('#pageShow').width((100 - leftWidth) + '%');
                }
                $('#split').mousedown(function() {
                    var float = $('<div style="position: fixed;width: 100%;height:100%;top:0;left:0;z-index: 9999"></div>');
                    function mouseMove(event) {
                        $('body').append(float);
                        initLeftAndRightWidth(event.pageX-2);
                        if($('#tplSize input:eq(2)').is(':checked')){
                            initTplContentScroll($('#tpl'));
                            initTplScroll($('.containerShow>iframe'));
                        }
                        tplEditor.resize();
                    }
                    $('body').mousemove(mouseMove);
                    $('body').mouseup(function () {
                        float.remove();
                        $("body").unbind("mousemove", mouseMove);
                    });
                });
            </script>
            <!--iframe工具栏-->
            <div id="tplSize" class="panel panel-default" style="margin:10px 10px 0;">
                <div class="panel-body" style="padding:5px;">
                    <div class="input-group" style="width:120px;float:left;margin: 2px;">
                        <div class="input-group-addon">宽度</div>
                        <input class="form-control" placeholder="模拟宽度" value="1080">
                    </div>
                    <div class="input-group" style="width:120px;float:left;margin: 2px;">
                        <div class="input-group-addon">高度</div>
                        <input class="form-control" placeholder="模拟高度" value="720">
                    </div>
                    <div class="input-group" style="width:50px;float:left;margin: 2px;">
                        <div class="input-group-addon">自动</div>
                        <div class="form-control">
                            <input type="checkbox" checked>
                        </div>
                    </div>
                    <div class="input-group" style="width:110px;float:left;margin: 2px;">
                        <input class="form-control" type="number" min="10" max="200" placeholder="缩放度">
                        <div class="input-group-addon">%</div>
                    </div>
                </div>
            </div>
            <iframe id="tpl" src="{$url}" style="border: solid 1px #b2b2b2;"></iframe>
            <script>
                $('#tplSize input:eq(3)').change(function(){
                    var webWidth = $('#tplSize input:eq(0)').val();
                    var webHeight = $('#tplSize input:eq(1)').val();
                    var scale = ($(this).val()/100);
                    $('#tpl').css('transform', 'scale(' + scale + ')');
                    var rightwidth = $('#tpl').parent().width();
                    $('#tpl').css('marginLeft', (webWidth - rightwidth) / -2);
                    $('#tpl').css('marginTop', (1 - scale) / -2 * webHeight + 10);
                });

                window.onbeforeunload=function(event){
                    return '正在编辑状态';
                }
                function initTplScroll(dom){
                    var webWidth = $('#tplSize input:eq(0)').val();
                    var webHeight = $('#tplSize input:eq(1)').val();
                    $(dom).css('width',webWidth);
                    $(dom).css('height',webHeight);
                    var rightwidth = $(dom).parent().width();
                    var padding=10;
                    var scale = (rightwidth-padding*2)/webWidth;
                    $(dom).css('transform','scale('+scale+')');
                    $(dom).css('marginLeft',(webWidth-rightwidth)/-2);
                    $(dom).css('marginTop',(1-scale)/-2*webHeight+10);
                }
                function initTplContentScroll(dom){
                    if($('#tplSize input:eq(2)').is(':checked')) {
                        var webWidth = $('#tplSize input:eq(0)').val();
                        var webHeight = $('#tplSize input:eq(1)').val();
                        $(dom).css('width', webWidth);
                        $(dom).css('height', webHeight);
                        var rightwidth = $(dom).parent().width();
                        var padding = 10;
                        var scale = (rightwidth - padding * 2) / webWidth;
                        $('#tplSize input:eq(3)').val(parseInt(scale * 100));
                        $(dom).css('transform', 'scale(' + scale + ')');
                        $(dom).css('marginLeft', (webWidth - rightwidth) / -2);
                        $(dom).css('marginTop', (1 - scale) / -2 * webHeight + 10);
                    }
                }
                initTplContentScroll($('#tpl'));
                //浏览器宽度调整
                $(window).resize(function() {
                    initLeftAndRightWidth($('#leftActionPanel').width());
                    initTplContentScroll($('#tpl'));
                    tplEditor.resize();
                });

                //获取元素内所有的注释元素
                function getCommentNodes(e,pregMatch){
                    var returnArr=[];
                    var temp;
                    var tree;
                    tree=document.createTreeWalker(e,NodeFilter.SHOW_COMMENT,null,null);
                    while(temp=tree.nextNode()){
                        if(pregMatch!=undefined){
                            if(temp.data.match(pregMatch)){
                                returnArr.push(temp);
                            }
                        }else{
                            returnArr.push(temp);
                        }


                    }
                    return returnArr;
                }
//                function createImageDataByDom(dom,funccallback){
//                    dom.find('img').each(function(){
//                        this.crossOrigin = "*";
//                        var canvas = document.createElement("canvas");
//                        canvas.width = this.width;
//                        canvas.height = this.height;
//                        var ctx = canvas.getContext("2d");
//                        ctx.drawImage(this, 0, 0, this.width, this.height);
//                        var data = canvas.toDataURL("image/png");
//                        $(this).data('url',$(this).attr('src'));
//                        $(this).attr('src',data);
//                    });
//                    html2canvas(dom[0], {
//                        onrendered: function (canvas) {
//                            var url = canvas.toDataURL();
//                            funccallback(url);
//                            dom.find('img').each(function(){
//                                $(this).attr('src',$(this).data('url'));
//                                $(this).data('url','');
//                            });
//                        }
//                    });
//                }

//                isImgLoad('./commonModule/commonModule/bottom.png',function(result){
//                    console.log(result);
//                });
//                getCommentNodes(document)

                //生成模块的现在显示图片
//                allComment = getCommentNodes($("#tpl").contents().find('body')[0]);
//                var commonNode = allComment[0];
//                if(commonNode.nodeValue.match(/useMod (\S+)$/)!==null){
//                    var nodeName = commonNode.nodeValue.match(/useMod (\S+)$/)[1]
//
//                    console.log($(commonNode).nextAll(':not(style)').eq(0));
//                    createImageDataByDom($(commonNode).nextAll(':not(style)').eq(0),function(data){
//                        console.log(data);
//                        var w=window.open('about:blank','image from canvas');
//                        w.document.write("<img src='"+data+"' alt='from canvas'/>");
//                    });
//                    console.log('是'+nodeName+'类型的');
//                }
            </script>
        </section>
    </div>
</body>
</html>