<html>
<head>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,minimal-ui">
    <link href="//cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="//cdn.bootcss.com/jquery/3.2.1/jquery.js"></script>
    <script src="//cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <style>
        body{
            margin:0;
            padding: 0;
        }
        #fileList>table>tbody>tr>.fileName span{
            opacity: 0;
            margin-left: 10px;
        }
        #fileList>table>tbody>tr>.fileName:hover span{
            opacity: 1;
        }
        #console{
            position:fixed;
            width: 100%;
            bottom:0px;
            margin-bottom: 1px;
        }
        #console .panel-body{
            padding: 0 15px;
        }
        #console .panel-body .accordion-inner{
            max-height: 300px;
            overflow-y: scroll;
        }
        .dropdown-menu>ul {
            padding: 0;
        }
        .dropdown-menu>ul>li{
            list-style: none;
        }
        .dropdown-menu>ul>li>a {
            display: block;
            padding: 3px 20px;
            clear: both;
            font-weight: 400;
            line-height: 1.42857143;
            color: #333;
            white-space: nowrap;
            text-overflow: ellipsis;
            overflow: hidden;
            cursor: pointer;
        }
        .dropdown-menu>ul>li>a:hover {
            color: #262626;
            text-decoration: none;
            background-color: #f5f5f5;
        }
    </style>
    <script>
        function reloadSessionStage(actionId,now,maxCount){
            if(actionState[actionId]==null){
                console.log(actionId+'已经销毁');
            }
            if(maxCount==undefined){
                maxCount=0;
            }
            $.post('mysqlAction.php',{
                action:'getSessionState',
                now:now
            },function(data){
                data = JSON.parse(data);
                if(data.program==100){
                    console.log('进程完成');
                }else{
                    if(maxCount<30){
                        reloadSessionStage(actionId,data.program,maxCount+1);
                    }
                }
                if(data.program==100){
                    $('#actionProgress>div').css('width','100%');
                    $('#actionProgress>div').html(data.text);
                    setTimeout(function(){
                        $('#actionProgress>div').css('width','0%');
                        $('#actionProgress>div').html('');
                    },1000);
                }else{
                    $('#actionProgress>div').css('width',parseInt(data.program)+'%');
                    $('#actionProgress>div').html(data.text);
                }
            });
        }
        var actionState = {
        };
        function post(url,params,callFunc){
            var actionId = parseInt(Math.random()*100000);
            actionState[actionId] = true;
            (function(actionId){
                $.post(url,params,function(data){
                    if(data===''){
                        actionState[actionId] = null;
                        return false;
                    }
                    var data2 = JSON.parse(data);
                    if(data2.return == false){
                        actionState[actionId] = null;
                        return false;
                    }
                    callFunc(data);
                });
                setTimeout(function(){
                    reloadSessionStage(actionId);
                },20);
            })(actionId);
        }
    </script>
</head>
<body>
    <div id="actionProgress" class="progress" style="border-radius: 0;">
        <div class="progress-bar progress-bar-success progress-bar-striped active" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%"></div>
    </div>
    <ul id="myTab" class="nav nav-tabs">
        <li class="active"><a href="#home" data-toggle="tab">页面</a></li>
        <li><a href="#gitAdmin" data-toggle="tab" onclick="initGitState()">运行环境git状态</a></li>
        <li><a id="dataAdminTab" href="#dataAdmin" data-toggle="tab">数据</a></li>
        <li class="dropdown">
            <a href="#" id="myTabDrop1" class="dropdown-toggle"
               data-toggle="dropdown">Java
                <b class="caret"></b>
            </a>
            <ul class="dropdown-menu" role="menu" aria-labelledby="myTabDrop1">
                <li><a href="#jmeter" tabindex="-1" data-toggle="tab">jmeter</a></li>
                <li><a href="#ejb" tabindex="-1" data-toggle="tab">ejb</a></li>
            </ul>
        </li>
    </ul>
    <style>
        #myTabContent:after{
            content:' ';width:100%;height:40px;float: left;clear: both;
        }
    </style>
    <div id="myTabContent" class="tab-content">
        <div class="tab-pane fade in active" id="home">
            <section id="fileList">
                <table class="table table-striped">
                    <thead></thead>
                    <tbody>
                    {foreach $fileList as $file}
                        {if in_array($file,array('.','commonModule','template'))}{continue}{/if}
                        {if substr($file,-4)!=='.tpl'}
                        <tr>
                            <td><a target="_blank" href="pageEditAdmin.php?file={$file}">{$file}</a></td>
                            <td class="fileName">{$httpFileConfig[$file]}<span data-id="{$file}" class="btn btn-default">修改</span></td>
                            <td></td>
                        </tr>
                        {/if}
                    {/foreach}
                    <tr>
                        <script>
                            function createPage(dom){
                                var allTd = $(dom).parents('tr').find('>td>input');
                                post('mysqlAction.php',{
                                    action:'createPage',
                                    fileName:allTd.eq(0).val(),
                                    title:allTd.eq(1).val(),
                                },function(data){
                                    //运行完,进行刷新
                                    location.href = location.href;
                                });
                            }
                        </script>
                        <td><input class="form-control" placeholder="新增文件名"></td>
                        <td><input class="form-control" placeholder="名称"></td>
                        <td><button type="button" class="btn btn-default" onclick="createPage(this)">新增</button></td>
                    </tr>
                    </tbody>
                </table>
            </section>
        </div>
        <div class="tab-pane fade" id="gitAdmin" style="padding-top: 10px;">
            <section id="github" class="container">
                <div class="panel panel-default">
                    <ul class="list-group">
                        <li class="list-group-item">
                            当前正在<span id="githubState"></span>版本
                            <div class="btn-group">
                                <button id="githubStateChange" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    切换到分支<span class="caret"></span>
                                </button>
                                <ul id="floatDom" class="dropdown-menu"></ul>
                            </div>
                            <div class="btn-group">
                                <button id="commitlog" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    重置到节点<span class="caret"></span>
                                </button>
                                <div class="dropdown-menu" style="height:400px;overflow-y: scroll;width: 400px;">
                                    <canvas style="position:absolute;left:0;"></canvas>
                                    <ul id="checkoutCommit"></ul>
                                </div>
                            </div>
                            <button id="githubClean" type="button" class="btn btn-default">重置</button>
                            <button id="githubPull" type="button" class="btn btn-default">拉取</button>
                        </li>
                        <li class="list-group-item" id="diffFile">
                            未commit文件
                        </li>
                        <li class="list-group-item" id="commitLog"></li>
                    </ul>
                </div>
                <script>
                    $('#githubStateChange').click(function(){
                        post('httpAdminMetaAction.php',{
                            action:'getBranch',
                        },function(data){
                            console.log(data);
                            data = JSON.parse(data);
                            var allBranch = data.branch;
                            $('#floatDom').html('');
                            for(var i=0;i<allBranch.length;i++){
                                var branchItem = allBranch[i];
                                if(branchItem.substring(0,1)!=='*'){
                                    if(branchItem.substring(0,16)!=='  remotes/origin'){
                                        $('#floatDom').append('<li><a href="#" value="'+branchItem.substring(2)+'">本地:'+branchItem.substring(2)+'</a></li>');
                                    }
                                }
                            }
                            $('#floatDom').append('<li role="separator" class="divider"></li>');
                            for(var i=0;i<allBranch.length;i++){
                                var branchItem = allBranch[i];
                                if(branchItem.substring(0,1)!=='*'){
                                    if(branchItem.substring(0,16)=='  remotes/origin'){
                                        $('#floatDom').append('<li><a href="#" value="'+branchItem.substring(2)+'">公共:'+branchItem.substring(17)+'</a></li>');
                                    }
                                }
                            }
                            $('#floatDom').append('<li role="separator" class="divider"></li>');
                            $('#floatDom').append('<li><a href="#" active="pull">分支找不到?需要点击同步一下远程</a></li>');
                        });
                    });
                    function checkout(){
                        var selectBranch = $(this).find('>a').attr('value');
                        if(selectBranch==undefined){
                            post('httpAdminMetaAction.php',{
                                action:'updateBranch',
                                sName:selectBranch
                            },function(data){
                                data = JSON.parse(data);
                                initGitState();
                            });
                        }else{
                            post('httpAdminMetaAction.php',{
                                action:'checkout',
                                sName:selectBranch
                            },function(data){
                                if(data!=''){
                                    data = JSON.parse(data);
                                }
                                initGitState();
                            });
                        }
                    }
                    $('#floatDom').on('click','>li',checkout);
                    $('#checkoutCommit').on('click','>li',checkout);
                    $('#githubPull').click(function(){
                        post('httpAdminMetaAction.php',{
                            action:'pull'
                        },function(data){
                            data = JSON.parse(data);
                            initGitState();
                        });
                    });
                    {literal}
                    $('#commitlog').click(function(){
                        $('#commitlog').parent().find('ul').html('');
                        post('httpAdminMetaAction.php',{
                            action:'commitlog'
                        },function(data){
                            data = JSON.parse(data);
                            var commithashList = {};
                            for(var i=0;i<data.length;i++){
                                data[i] = data[i].match(/^([\*|\\|\||\/|\s]+)((\S{7}) \(([^\)]*)\) \(([^\)]+)\) (\S+) (\S+ \S+))?/).slice(3);
                                if(data[i][0]!=undefined){
                                    var parent = data[i][1].split(' ');
                                    commithashList[data[i][0]] = {
                                        parent:parent,
                                        title:data[i][2],
                                        author:data[i][3],
                                        time:data[i][4],
                                        child:[],
                                    }
                                }
                            }
                            for(var i in commithashList){
                                for(var j=0;j<commithashList[i].parent.length;j++){
                                    if(commithashList[i].parent[j]!==''){
                                        commithashList[commithashList[i].parent[j]].child.push(i);
                                    }
                                }
                            }
                            var isTabUse = [];//是否占着tab位
                            var isTabUseColor = [];
                            var isTabMaxUse = 0;
                            $('#commitlog').parent().find('.dropdown-menu>canvas').attr('height', data.length*26  );
                            $('#commitlog').parent().find('.dropdown-menu>canvas').attr('width',30);
                            var cxt=$('#commitlog').parent().find('.dropdown-menu>canvas')[0].getContext("2d");
                            cxt.clearRect(0,0,cxt.canvas.width,cxt.canvas.height);
                            function getRandomColor(){
                                function getPer(){
                                    return '0123456789abcdef'[Math.floor(Math.random()*16)];
                                }
                                var colorBase = ['ff','97',getPer()+getPer()];
                                colorBase = colorBase.sort(function(){ return 0.5 - Math.random() })
                                return '#'+colorBase.join('');
                            }
                            for(var i=0;i<data.length-1;i++){
                                var commitHash = data[i][0];
                                if(commitHash!=undefined){
                                    var childList = commithashList[commitHash].child;
                                    if(childList && childList.length>0){
                                        if(childList.length>1){//从上到下合并
                                            var childPos = isTabUse.indexOf(childList[0]);
                                            for(var j=1;j<childList.length;j++){
                                                childPos = Math.min(childPos,isTabUse.indexOf(childList[j]));
                                            }
                                            isTabUse[childPos] = commitHash;
                                            for(var j=0;j<childList.length;j++){
                                                var temp = isTabUse.indexOf(childList[j]);
                                                if(temp!=-1 && temp!=childPos){
                                                    isTabUse[temp] = null;
                                                }
                                            }
                                        }
                                        else{
                                            if(commithashList[childList[0]].parent.length>1){//从上到下分叉
                                                if(commithashList[childList[0]].parent.indexOf(commitHash)==0){
                                                    var childPos = isTabUse.indexOf(childList[0]);
                                                }else{
                                                    for(var j=0;j<=isTabUse.length;j++){
                                                        if(isTabUse[j]==undefined || isTabUse[j]==null){
                                                            var childPos = j;break;
                                                        }
                                                    }
                                                    isTabUseColor[childPos] = getRandomColor();
                                                }
                                            }else{//从上到下直线
                                                var childPos = isTabUse.indexOf(childList[0]);
                                            }
                                            isTabUse[childPos] = commitHash;
                                        }
                                    }else{
                                        isTabUse[0] = commitHash;
                                        isTabUseColor[0] = getRandomColor();
                                    }
                                    if(isTabUse.length>isTabMaxUse){
                                        isTabMaxUse = isTabUse.length;
                                        (function(){
                                            var tepData = cxt.getImageData(0,0,cxt.canvas.width,cxt.canvas.height);
                                            $('#commitlog').parent().find('.dropdown-menu>canvas').attr('width',isTabMaxUse*10+4);
                                            cxt.putImageData(tepData,0,0);
                                        })();
                                    }
                                    //展示这一行
                                    var show = 0;
                                    for(var j=0;j<isTabUse.indexOf(commitHash);j++){
                                        show ++;
                                    }
                                    commithashList[commitHash].tab = show;
                                    commithashList[commitHash].line = $('#commitlog').parent().find('ul li').length;
                                    (function(){
                                        var centerX = show*10+8;
                                        var centerY = $('#commitlog').parent().find('ul li').length*26+13;
                                        cxt.lineWidth=2;
                                        cxt.strokeStyle="#000000";
                                        cxt.fillStyle=isTabUseColor[show];//"#42768b";
                                        for(var j=0;j<childList.length;j++){
                                            var centerX2 = commithashList[childList[j]].tab*10+8;
                                            var centerY2 = commithashList[childList[j]].line*26+13;

                                            if(commithashList[childList[j]].tab==show){
                                                cxt.moveTo(centerX,centerY-4);
                                                cxt.lineTo(centerX,centerY2+13);
                                                cxt.lineTo(centerX2,centerY2+4);
                                            } else if(centerX2>centerX){
                                                cxt.moveTo(centerX+3,centerY);
                                                cxt.lineTo(centerX2,centerY-13);
                                                cxt.lineTo(centerX2,centerY2+4);
                                            }else{
                                                cxt.moveTo(centerX,centerY);
                                                cxt.lineTo(centerX,centerY2+13);
                                                cxt.lineTo(centerX2+3,centerY2);
                                            }
                                            cxt.stroke();
                                        }
                                        cxt.beginPath();
                                        cxt.arc(centerX,centerY,4,0,Math.PI*2,true);
                                        cxt.closePath();
                                        cxt.stroke();
                                        cxt.fill();
                                    })();
                                    $('#commitlog').parent().find('ul').append('<li><a value="'+commitHash+'">'+commitHash+' '+commithashList[commitHash].title+'</a></li>');
                                }
                            }
                            $('#commitlog').parent().find('ul').css('paddingLeft',isTabMaxUse*10);
                            var tepData = cxt.getImageData(0,0,cxt.canvas.width,cxt.canvas.height);
                            $('#commitlog').parent().find('.dropdown-menu>canvas').attr('height', $('#commitlog').parent().find('ul li').length*26  );
                            $('#commitlog').parent().find('.dropdown-menu>canvas').attr('width',isTabMaxUse*10+4);
                            cxt.putImageData(tepData,0,0);
                        });
                    });
                    {/literal}
                    $('#githubClean').click(function(){
                        post('httpAdminMetaAction.php',{
                            action:'githubClean'
                        },function(data){
                            data = JSON.parse(data);
                            initGitState();
                        });
                    });
                    function commit(){
                        var message = window.prompt('做了什么？');
                        if(message){
                            post('httpAdminMetaAction.php',{
                                action:'commit',
                                message:message
                            },function(data){
                                data = JSON.parse(data);
                                console.log(data);
                                initGitState();
                            });
                        }
                    }
                    function push(){
                        post('httpAdminMetaAction.php',{
                            action:'push',
                        },function(data){
                            data = JSON.parse(data);
                            console.log(data);
                            initGitState();
                        });
                    }
                    function initGitState(){
                        post('httpAdminMetaAction.php',{
                            action:'getBranch',
                        },function(data){
                            data = JSON.parse(data);
                            var allBranch = data.branch;
                            var allDiff = data.diff;

                            $('#diffFile').html('');
                            for(var i=0;i<allDiff.length;i++){
                                $('#diffFile').append($('<div>'+allDiff[i]+'</div>'));
                            }
                            $('#diffFile').append($('<button type="button" class="btn btn-default" onclick="commit()">commit</button>'));

                            var commitLog = data.commit;
                            $('#commitLog').html('');
                            for(var i=0;i<commitLog.length;i++){
                                $('#commitLog').append($('<div>'+commitLog[i]+'</div>'));
                            }
                            $('#commitLog').append($('<button type="button" class="btn btn-default" onclick="push()">push</button>'));
                            for(var i=0;i<allBranch.length;i++){
                                var branchItem = allBranch[i];
                                if(branchItem.substring(0,1)=='*'){
                                    $('#githubState').html(branchItem.substring(2));
                                }
                            }
                        });
                    }
                </script>
            </section>
        </div>
        <style>
            {literal}
            #dataAdmin{margin: 10px auto;}
            #dataAdmin>.panel{float: left;margin: 0 5px 20px 5px;height: 200px;}
            @media screen and (min-width: 1200px) {
                #dataAdmin{width:1040px;}
                #dataAdmin>.panel{width: 250px;}
            }
            @media screen and (min-width: 900px) and (max-width: 1199px){
                #dataAdmin{width:840px;}
                #dataAdmin>.panel{width: 200px;}
            }
            @media screen and (min-width: 700px) and (max-width: 899px){
                #dataAdmin{width:640px;}
                #dataAdmin>.panel{width: 200px;}
            }
            @media screen and (min-width: 550px) and (max-width: 699px){
                #dataAdmin{width:480px;}
                #dataAdmin>.panel{width: 230px;}
            }
            @media screen and (max-width: 549px){
                #dataAdmin{width:90%;}
                #dataAdmin>.panel{width: 100%;margin: 0 0 20px;}
            }
            #showTableColumn table [data-id=maxLength] input{
                max-width: 60px;min-width:37px;padding:6px;text-align: center;
            }
            #showTableColumn table tbody tr td:first-child label{
                line-height: 34px;
            }
            #showTableColumn table tbody tr td:first-child span{
                border:solid 1px #a96449;
                border-radius: 4px;
                color: #a96449;
                cursor: pointer;
                display: none;
            }
            #showTableColumn table tbody tr:hover td:first-child span{
                display:inline-block;
            }
            #addTable>.panel-body{
                text-align: center;padding: 0
            }
            #addTable>.panel-body>div:first-child{
                height: 33%;line-height: 66px;padding: 15px;
            }
            #addTable>.panel-body>div:first-child>input{
                display: none;
            }
            #addTable:hover>.panel-body>div:first-child>input{
                display: block;
            }
            .has-error .form-control::-moz-placeholder { color: #993423; }
            .has-error .form-control::-webkit-input-placeholder { color:#993423; }
            .has-error .form-control:-ms-input-placeholder { color:#993423; }
            {/literal}
        </style>
        <div class="tab-pane fade" id="dataAdmin">
            <script>
                var allDataType = null;
                function getDataTypes(nowType,allType){
                    if(allType!==undefined){
                        allDataType = allType;
                    }
                    var html = '<select class="form-control">';
                    for(var i=0;i<allDataType.length;i++){
                        if(allDataType[i].type==nowType){
                            html+= '<option selected value="'+allDataType[i].type+'">'+allDataType[i].name+'</option>';
                        }else{
                            html+= '<option value="'+allDataType[i].type+'">'+allDataType[i].name+'</option>';
                        }
                    }
                    html+= '</select>';
                    return html;
                }
                function getForeignKey(nowType){
                    var html = '<select class="form-control"><option value="">无</option>';
                    for(var i=0;i<getForeignKey.allType.length;i++){
                        if(getForeignKey.allType[i].Name==nowType){
                            html+= '<option selected value="'+getForeignKey.allType[i].Name+'">'+getForeignKey.allType[i].Name+'</option>';
                        }else{
                            html+= '<option value="'+getForeignKey.allType[i].Name+'">'+getForeignKey.allType[i].Name+'</option>';
                        }
                    }
                    html+= '</select>';
                    return html;
                }
                {*var allTableApiClass = {json_encode($tableApiClass)};*}
                $('#dataAdminTab').click(function(){
                    post('mysqlAction.php',{
                        action:'tables',
                        databases:'{$useDataBases[0]}'
                    },function(data){
                        $('#dataAdmin').html('');
                        data = JSON.parse(data);
                        getForeignKey.allType = data;
                        for(var i=0;i<data.length;i++){
                            $('#dataAdmin').append('<div class="panel panel-default" data-database="'+data[i].database+'" data-name="'+data[i].Name+'">'+
                                '<div class="panel-heading">'+data[i].Name+'</div>'+
                                '<div class="panel-body">'+
                                    '<p>创建于'+data[i].Create_time+'</p>'+
                                    '<p>使用引擎'+data[i].Engine+'</p>'+
                                    '<p>数据量'+data[i].Rows+'</p>'+
                                    '<p>'+data[i].Comment+'</p>'+
                                '</div>'+
//                                '<div class="panel-footer">Panel footer</div>'+
                            '</div>');
                        }
                        $('#dataAdmin').append('<div id="addTable" class="panel panel-default" data-database="'+data[0].database+'">'+
                                '<div class="panel-body">'+
                                    '<div class="form-group"><input class="form-control" placeholder="请输入新表名字"></div>'+
                                    '<div><span class="glyphicon glyphicon-plus" aria-hidden="true" style="font-size: 50px;color: #adadad;"></span></div>'+
                                '</div>'+
                            '</div>');
                    });
                });
                //初始化表后台信息
                function initTableInfo(database,tableName,option){
                    post('mysqlAction.php',{
                        action:'getDataApi',
                        database:database,
                        name:tableName,
//                        tableApi:allTableApiClass
                    },function(data){
                        data = JSON.parse(data);
                        var className = data.className;
                        post('mysqlAction.php',{
                            action:'showTableAdmin',
                            class:className,
                            option:option
                        },function(data){
                            data = JSON.parse(data);
                            $('#showTableColumn').show();
                            $('#showTableColumn').data('id',className);
                            $('#showTableColumn').data('type','update');
                            $('#showTableColumn>.panel>.panel-body').html('');
                            var table = $('<table class="table"><thead><tr>' +
                                    '<th style="min-width: 100px">字段</th>' +
                                    '<th style="min-width: 100px">名称</th>' +
                                    '<th style="min-width: 100px">类型</th>' +
                                    '<th style="min-width: 100px">最大长度</th>' +
                                    '<th style="min-width: 100px">是否必填</th>' +
                                    '<th style="min-width: 100px">默认值</th>' +
                                    '<th style="min-width: 100px">主键</th>' +
                                    '<th style="min-width: 100px">表内唯一</th>' +
                                    '<th style="min-width: 100px">列表隐藏</th>' +
                                    '<th style="min-width: 100px">外键关联</th>' +
                                    '</tr></thead><tbody></tbody></table>');
                            for(var i in data.option){
                                table.append($('<tr data-id="'+i+'">' +
                                        '<td><p class="form-control-static">'+i+'<span class="glyphicon glyphicon-remove" aria-hidden="true"></span></p></td>' +
                                        '<td data-id="title"><input class="form-control" value="'+data.option[i].title+'"/></td>' +
                                        '<td data-id="dataType">'+
                                            getDataTypes((data.option[i].AUTO_INCREMENT?'AUTO_INCREMENT':data.option[i].dataType),data.allMysqlColType)+
                                        '</td>' +
                                        '<td data-id="maxLength" data-value="'+data.option[i].maxLength+'">'+
                                        (['varchar','char'].indexOf(data.option[i].dataType)>-1?(
                                                '<input type="number" class="form-control" value="'+data.option[i].maxLength+'">'
                                        ):'')+'</td>' +
                                        '<td data-id="notNull"><input class="form-control" type="checkbox" '+(data.option[i].notNull?'checked':'')+'>'+'</td>' +
                                        '<td data-id="default"><input class="form-control" value="'+(data.option[i].default!==undefined?data.option[i].default:'')+'">'+'</td>' +
                                        '<td data-id="primarykey"><input type="radio" class="form-control" name="primarykey"'+(data.option[i].primarykey===true?' checked="check"':'')+'></td>' +
                                        '<td data-id="unique"><input type="checkbox" class="form-control" name="unique"'+(data.option[i].unique===true?' checked="check"':'')+'></td>' +
                                        '<td data-id="listShowType"><input type="checkbox" class="form-control" '+(data.option[i].listShowType==='hidden'?' checked="check"':'')+'></td>' +
                                        '<td data-id="foreignKey">'+
                                            getForeignKey(data.option[i].foreignKey)+
                                        '</td>' +
                                    '</tr>'));
                            }
                            $('#showTableColumn>.panel>.panel-body').append(table);
                            $('[data-id=adminFileName]').attr('href',data.adminFileName);
                            $('[data-id=adminFileName]').removeAttr('disabled');

                            var isHasAutoIncrement = false;
                            $('[data-id=dataType] select').each(function(){
                                if($(this).val()=='auto_increment'){
                                    $(this).parents('tr').find('[data-id=primarykey]>input').click();
                                    $(this).parents('tr').find('[data-id=notNull]>input').attr("checked","true");
                                    $(this).parents('tr').find('[data-id=notNull]>input').attr("disabled","disabled");
                                    isHasAutoIncrement = true;
                                    return false
                                }
                            });
                            if(isHasAutoIncrement){
                                $('#showTableColumn [data-id=primarykey]>input').attr('disabled','disabled');
                            }else{
                                $('#showTableColumn [data-id=primarykey]>input').removeAttr('disabled');
                                $('#showTableColumn [data-id=notNull]>input').removeAttr('disabled');
                            }
                        });

                    });
                }
                $('#dataAdmin').on('click','>.panel',function(){
                    var database = $(this).data('database');
                    var tableName = $(this).data('name');
                    if(tableName==undefined){
                    }else{
                        initTableInfo(database,tableName);
                    }
                });
                $('#dataAdmin').on('click','#addTable .glyphicon',function(){
                    var newClassName = $('#addTable>.panel-body>div:eq(0)>input').val();
                    if(newClassName===''){
                        $('#addTable>.panel-body>div:eq(0)').addClass('has-error');
                    }else{
                        $('#addTable>.panel-body>div:eq(0)').removeClass('has-error');
                        post('mysqlAction.php',{
                            action:'getIsExistTable',
                            database:$(this).parents('.panel').data('database'),
                            name:newClassName,
                        },function(data){
                            if(data=='wrong'){
                                alert('表已存在');
                            }else{
                                data = JSON.parse(data);
                                allDataType = data;
                                $('#showTableColumn').show();
                                $('#showTableColumn').data('id',newClassName);
                                $('#showTableColumn').data('type','insert');
                                $('#showTableColumn>.panel>.panel-body').html('');
                                var table = $('<table class="table"><thead><tr>' +
                                        '<th style="min-width: 100px">字段</th>' +
                                        '<th style="min-width: 100px">名称</th>' +
                                        '<th style="min-width: 100px">类型</th>' +
                                        '<th style="min-width: 100px">最大长度</th>' +
                                        '<th style="min-width: 100px">是否必填</th>' +
                                        '<th style="min-width: 100px">默认值</th>' +
                                        '<th style="min-width: 100px">主键</th>' +
                                        '<th style="min-width: 100px">表内唯一</th>' +
                                        '<th style="min-width: 100px">列表隐藏</th>' +
                                        '</tr></thead><tbody></tbody></table>');
                                $('#showTableColumn>.panel>.panel-body').append(table);
                                $('[data-id=adminFileName]').removeAttr('href');
                                $('[data-id=adminFileName]').attr('disabled','disabled');
                            }
                        });
                    }
                });
            </script>
        </div>
        <div class="tab-pane fade" id="ejb">
            <p>Enterprise Java Beans（EJB）是一个创建高度可扩展性和强大企业级应用程序的开发架构，部署在兼容应用程序服务器（比如 JBOSS、Web Logic 等）的 J2EE 上。</p>
        </div>
    </div>
    <script>
        {literal}
        $('.fileName .btn').click(function(){
            var newName = prompt('请输入文件名');
            if(newName!==null){
                post('httpAdminMetaAction.php',{
                    action:'rename',
                    name:$(this).data('id'),
                    title:newName
                },function(data){
                    data = data.replace(/\n/g,'<br/>');
                    data = data.replace(/\s/g,'&nbsp;');
                    $('#console .panel-body .accordion-inner').append($('<div>'+data+'</div>'));
                    location.href = location.href;
                });
            }
        });
        {/literal}
    </script>
    <style>
        {literal}
        #showTableColumn{
            position: fixed;background-color: rgba(141, 141, 141, 0.48);left:0;top:0;width:100%;height:100%;
        }
        #showTableColumn>.panel{  position:absolute;  }
        @media screen and (min-width: 700px){
            #showTableColumn>.panel{ left:calc(50% - 336px);width:672px;}
        }
        @media screen and (max-width: 699px){
            #showTableColumn>.panel{ left: 2%;width:96%;}
        }
        @media screen and (min-height: 700px){
            #showTableColumn>.panel{ top: calc(50% - 330px);height:616px;}
        }
        @media screen and (max-height: 699px){
            #showTableColumn>.panel{ top: 2%;height:88%;}
        }
        {/literal}
    </style>
    <section id="showTableColumn" style="display: none;">
        <div class="panel panel-default">
            <div class="panel-heading">
                表后台
                <div class="btn-group btn-group-xs" role="group" aria-label="..." style="float: right;">
                    <button type="button" class="btn btn-default" onclick="addColumn()">插入新字段</button>
                    <a class="btn btn-default" data-id="adminFileName" target="_blank">后台</a>
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            放到tab
                            <span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu">
                            <li><a href="#">移除</a></li>
                            <li><a href="#">Dropdown link</a></li>
                            <li><a href="#">最后</a></li>
                        </ul>
                    </div>
                </div>
                <script>
                    function addColumn(){
                        var isHasAutoIncrement = false;
                        $('[data-id=dataType] select').each(function(){
                            if($(this).val()=='auto_increment'){
                                isHasAutoIncrement = true;
                                return false
                            }
                        });
                        $('#showTableColumn .panel-body>table>tbody').append($('<tr>' +
                            '<td data-id="name"><input class="form-control"/></td>' +
                            '<td data-id="title"><input class="form-control" value=""/></td>' +
                            '<td data-id="dataType">'+getDataTypes('int')+'</td>' +
                            '<td data-id="maxLength"></td>' +
                            '<td data-id="notNull"><input class="form-control" type="checkbox">'+'</td>' +
                            '<td data-id="default"><input class="form-control"></td>' +
                            '<td data-id="primarykey"><input type="radio" class="form-control" name="primarykey" '+(isHasAutoIncrement?'disabled="disabled"':'')+'></td>' +
                            '<td data-id="unique"><input type="checkbox" class="form-control" name="unique"></td>' +
                            '<td data-id="listShowType"><input type="checkbox" class="form-control"></td>' +
                            '<td data-id="foreignKey">'+
                                getForeignKey()+
                            '</td>' +
                        '</tr>'));
                    }
                </script>
            </div>
            <div class="panel-body" style="position: absolute;top:41px;bottom: 56px;width: 100%;overflow-y: scroll"></div>
            <div class="panel-footer" style="position: absolute;bottom: 0;width: 100%;">
                <button id="saveColumn" type="button" class="btn btn-default">保存</button>
                <button type="button" onclick="$('#showTableColumn').hide()" class="btn btn-default">取消</button>
                <script>
                    $('#saveColumn').click(function(){
                        var allColumnTr = $(this).parents('.panel').find('>.panel-body>table>tbody>tr');
                        var nowSate = {
                        };
                        allColumnTr.each(function(){
                            var columnName = $(this).data('id');
                            if(columnName==undefined){
                                columnName = $(this).find('>[data-id=name] input').val();
                            }
                            nowSate[columnName] = {
                            };
                            $(this).find('>[data-id]').each(function(){
                                var shuxingName = $(this).data('id');
                                if($(this).find('>.form-control').attr('type') == 'checkbox'){
                                    var shuxingValue = $(this).find('>.form-control').is(':checked');
                                }else if($(this).find('>.form-control').attr('type') == 'radio'){
                                    var shuxingValue = $(this).find('>.form-control').is(':checked');
                                }else if($(this).find('>.form-control').attr('type') == 'number'){
                                    var shuxingValue = parseInt($(this).find('>.form-control').val());
                                }else{
                                    var shuxingValue = $(this).find('>.form-control').val();
                                }
                                nowSate[columnName][shuxingName] = shuxingValue;
                            });
                        });
                        post('mysqlAction.php',{
                            action:($('#showTableColumn').data('type')=='insert'?'insertTable':'updateTableAdmin'),
                            databases:'{$useDataBases[0]}',
                            table:$('#showTableColumn').data('id'),
                            option:nowSate,
                        },function(data){
                            if($('#showTableColumn').data('type')=='insert'){
                                if(data=='0'){
                                    var database = '{$useDataBases[0]}';
                                    var tableName = $('#showTableColumn').data('id');
                                    initTableInfo(database,tableName,nowSate);
                                }
                            }
                        });
                    });
                    $('#showTableColumn').on('click','table tbody tr td .glyphicon',function(){
                        $(this).parents('tr').remove();
                    });
                </script>
            </div>
        </div>
    </section>
    <script>
        //切换分类
        $('#showTableColumn').on('change','table [data-id=dataType]',function(){
            var selectType = $(this).find('select').val();
            var maxLengthTd = $(this).parents('tr').find('[data-id=maxLength]');
            if(['varchar','char'].indexOf(selectType)>-1){
                maxLengthTd.html('<input type="number" class="form-control" value="'+maxLengthTd.data('value')+'">');
            }else{
                maxLengthTd.html('');
            }
            var isHasAutoIncrement = false;
            $('[data-id=dataType] select').each(function(){
                if($(this).val()=='auto_increment'){
                    $(this).parents('tr').find('[data-id=primarykey]>input').click();
                    $(this).parents('tr').find('[data-id=primarykey]>input').attr('disabled','disabled');
                    $(this).parents('tr').find('[data-id=notNull]>input').attr('disabled','disabled');
                    isHasAutoIncrement = true;
                    return false
                }
            });
            if(isHasAutoIncrement){
                $('#showTableColumn [data-id=primarykey]>input').attr('disabled','disabled');
            }else{
                $('#showTableColumn [data-id=primarykey]>input').removeAttr('disabled');
                $('#showTableColumn [data-id=notNull]>input').removeAttr('disabled');
            }
        });
    </script>
    <section id="console"  class="panel panel-default">
        <div class="panel-heading" data-toggle="collapse" href="#collapseOne">操作日志</div>
        <div class="panel-body">
            <div id="collapseOne" class="accordion-body collapse">
                <div class="accordion-inner">
                </div>
            </div>
            {*<div>*}
                {*<input type="email" class="form-control" id="exampleInputEmail1" placeholder="Email">*}
            {*</div>*}
        </div>
    </section>
</body>
</html>