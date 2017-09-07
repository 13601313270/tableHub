<style data-id="container_show_css">
    .containerShow .container .row{
        display: -webkit-box;display: -webkit-flex;display: -ms-flexbox;display: flex;flex-wrap: wrap;
    }
    .containerShow .container [is_edit_block=true]{
        margin:0;padding: 8px 5px;border: solid 1px black;
    }
    .containerShow .container [is_edit_block=true] .row{
        margin:0;padding: 8px 5px;border: solid 1px black;
    }
    .containerShow .container [is_edit_block=true] .row:hover{
        background-color: rgba(113, 165, 221, 0.46);
    }
    .containerShow .container .row[class*='append']{
        border: none;
        padding: 0;
        text-align: center;
        font-size: 10px;
        line-height: 10px;
        background-color: rgba(222, 42, 42, 0.62);
        margin: 1px 0;
    }
    .containerShow .container .row[class*='append']:hover{
        background-color: rgba(206, 39, 39, 0.75);
    }
    .containerShow .container .row>.append{
        background-color: rgba(206, 39, 39, 0.75);
        width: 0;
        position:relative;
    }
    .containerShow .container .row>.append>span{
        cursor: pointer;
        width: 14px;
        height: 14px;
        background-color: rgba(206, 39, 39, 0.75);
        margin-left: -6px;
        margin-top: 2px;
        text-align: center;
        color: white;
        font-size: 10px;
        line-height: 10px;
        position: absolute;
        display: block;
        z-index: 3;
    }

    .containerShow .container .row[class*='on']>[class*='col-xs-']{
        border-left: solid 3px rgba(206, 39, 39, 0.75);
    }
    .containerShow .container [is_edit_block=true] [class*='col-xs-']{
        padding:5px 8px;border:solid 1px black;
    }
    .containerShow .container [is_edit_block=true] [class*='col-xs-']:hover{
        background-color: rgba(113, 165, 221, 0.46);
    }
    .containerShow .container [is_edit_block=true] .col-xs-12{
        border:none;
    }
    .containerShow .container .col-xs-12:hover{
        background-color: rgba(255, 255, 255, 0);
    }
    .containerShow>.on{
        background-color: rgba(41, 121, 206, 0.62);
    }
    .containerShow>.on:hover{
        background-color: rgba(41, 121, 206, 0.7);
    }
    .containerShow .container .on{
        background-color: rgba(41, 121, 206, 0.62);
    }
    .containerShow .container .on:hover{
        background-color: rgba(41, 121, 206, 0.7);
    }
    .breadcrumb>li+li:before{
        font-family: 'Glyphicons Halflings';content: "\e258";
    }
</style>
<div class="panel panel-default" style="margin:5px 0 0 5px;">
    <div class="panel-body" style="padding:5px;">
        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group" style="font-family:iconfont;">
                <button class="deleteAppend btn btn-default" type="button">删除</button>
                <button class="btn btn-default">
                    <span class="icon-fengexianshu"></span>竖分
                </button>
                <button class="btn btn-default">
                    <span class="icon-fengexianheng"></span>横分
                </button>
            </div>
            {*<div class="btn-group" role="group" aria-label="...">*}
            {*<button type="button" class="btn btn-default">横1</button>*}
            {*<button type="button" class="btn btn-default">横2</button>*}
            {*<button type="button" class="btn btn-default">横3</button>*}
            {*</div>*}
        </div>
    </div>
</div>
<div class="panel panel-default" style="margin:5px 0 0 5px;">
    <div class="panel-body" style="padding:5px;">
        <ol class="breadcrumb">
            <li><a href="#">Home</a></li>
            <li><a href="#">Library</a></li>
            <li class="active">Data</li>
        </ol>
        <div class="containerShow">
            <iframe style="border: 1px solid rgb(178, 178, 178);width: 100%;height: 100%;"></iframe>
        </div>
    </div>
</div>
<script>
    (function(){
        $('[href="#containerAdmin"]').click(function(){
            {literal}
            var appEndCss = '<style>[on_edit_hover=true]{background-color:rgba(44, 130, 221, 0.6);box-shadow: 0 0 40px 5px rgba(80, 80, 80, 0.5);}<\/style>';
            {/literal}
            if($($('#tpl')[0].contentDocument).find('head').html().indexOf(appEndCss)==-1){
                $($('#tpl')[0].contentDocument).find('head').append(appEndCss);
            }
            var html = $($('#tpl')[0].contentDocument).find('body').html();
            if(html.indexOf('<!--blockBegin name(')>-1) {
                console.log('存在block');
                (function(){
                    initIframeByHtml($('.containerShow>iframe'),'<html><head>' +
                            '<style>'+$('[data-id="container_show_css"]').html().replace(/.containerShow .container/g,'.container')+'<\/style>' +
                            '<\/head>'+$($('#tpl')[0].contentDocument).find('body').parent().html()+'</html>');
                    $($('.containerShow>iframe')[0].contentDocument).find('body [on_edit_hover]').attr('on_edit_hover','');
                    initTplScroll($('.containerShow>iframe'));
                    $(window).resize(function() {
                        initTplScroll($('.containerShow>iframe'));
                    });
                    //然后进行配对
                    function initCom(domClone,dom){
                        domClone[0].target = dom[0];
                        var cloneChildren = domClone.children();
                        var children = dom.children();
                        for(var i=0;i<cloneChildren.length;i++){
                            initCom($(cloneChildren[i]),$(children[i]));
                        }
                    }
                    initCom($($('.containerShow>iframe')[0].contentDocument).find('body'),$($('#tpl')[0].contentDocument).find('body'));

                    $($($('.containerShow>iframe')[0].contentDocument).find('body')).on('mouseover','*',function(event){
                        $(this.target).parents('body').find('[on_edit_hover]').attr('on_edit_hover','');
                        if(!$(this).is('body')){
                            if($(this.target).is('.row,[class*=col-xs-]')){
                                $(this.target).attr('on_edit_hover','true');
                            }else{
                                $(this.target).parents('.row,[class*=col-xs-]').eq(0).attr('on_edit_hover','true');
                            }

                        }
                        event.stopPropagation();
                    });
                    $('.containerShow>iframe').mouseleave(function(){
                        $($('#tpl')[0].contentDocument).find('body [on_edit_hover]').attr('on_edit_hover','');
                    });
//                    //去掉左侧的include的内容
//                    var allComment = getCommentNodes($($('.containerShow>iframe')[0].contentDocument).find('body')[0],/useMod(End)? (\S+)\.mod\.tpl/);
//                    console.log(allComment);
//                    //去掉useMod
//                    for(var j=0;j<allComment.length;j++){
////                        console.log(allComment[j]);
////                        console.log($(allComment[j]).html());
//                        var beginNext = $.makeArray($(allComment[j]).nextAll());
//                        var endPrev = $.makeArray($(allComment[j+1]).prevAll());
//                        for(var k=0;k<beginNext.length;k++){
//                            if(endPrev.indexOf(beginNext[k])>-1){
//                                $(beginNext[k]).remove();
//                            }
//                        }
//                    }
                    //去掉非布局元素
                })();
//                var allBlock = getCommentNodes($($('.containerShow>iframe')[0].contentDocument).find('body')[0],/<!--blockBegin name\(\S+\)--\>([\s|\S]*?)\<!--blockEnd--\>/);
                var allBlock = getCommentNodes($($('.containerShow>iframe')[0].contentDocument).find('body')[0],/blockBegin name\(\S+\)/);
//                var allBlock = $($('#tpl')[0].contentDocument).find('body').html().match(/<!--blockBegin name\(\S+\)--\>([\s|\S]*?)\<!--blockEnd--\>/g);
                for(var i=0;i<allBlock.length;i++){
                    $(allBlock[i]).parent().attr('is_edit_block',true);
                    $(allBlock[i]).remove();
                }
//                for(var i=0;i<allBlock.length;i++){
//                    var blockHtml = allBlock[i].match(/<!--blockBegin name\(\S+\)--\>([\s|\S]*?)\<!--blockEnd--\>/)[1];
//                    if(blockHtml!=''){
//                        var blockDom =$('<div>'+blockHtml+'</div>');
//                        if(blockDom.html()!=undefined){
////                            console.log(blockDom.html());
//                            var allComment = getCommentNodes(blockDom[0]);
////                            console.log(allComment);
//                            //去掉comment之间的部分
//                            for(var j=0;j<allComment.length;j++){
//                                console.log(allComment[j]);
//                                console.log($(allComment[j]).html());
//                                var beginNext = $.makeArray($(allComment[j]).nextAll());
//                                var endPrev = $.makeArray($(allComment[j+1]).prevAll());
//                                for(var k=0;k<beginNext.length;k++){
//                                    if(endPrev.indexOf(beginNext[k])>-1){
//                                        $(beginNext[k]).remove();
////                                        console.log(beginNext[k]);
//////                                        console.log(beginNext[k]);
//                                    }
//                                }
//                            }
//                        }
//                        $('.containerShow').html('');
//                        $('.containerShow').append(blockDom);
//                    }
//                }
            }else{
                console.log('不存在block');
            }
        });
        //1竖向 2横向 3空
        function selectBlock(dom,type){
//            console.log(dom);
            if(type==1){
                $(dom).children().before($('<div class="row append"><div class="col-xs-12">+</div></div>'));
                $(dom).append($('<div class="row append"><div class="col-xs-12">+</div></div>'));
                console.log('竖向排列');
            }else if(type==2){
                $(dom).children().before($('<div class="append"><span>+</span></div>'));
                $(dom).append($('<div class="append"><span>+</span></div>'));
                console.log('横向排列');
            }else{
                console.log('空');
            }
        }
        function clearTemp(){
            $($('.containerShow>iframe')[0].contentDocument).find('body .append').remove();
            $($('.containerShow>iframe')[0].contentDocument).find('body>div:eq(1)>.container').removeClass('on');
            $($('.containerShow>iframe')[0].contentDocument).find('body .on').removeClass('on');
            $($('.containerShow>iframe')[0].contentDocument).find('body .container [class*=col-xs-]').removeClass('on');
        }

        //选择了一个block内的布局元素
        function showAllParentDomNav(){
            var allParentContainerDom = $(this).parents('[is_edit_block=true] [class*=col-xs-],.row');
            console.log(this);
            console.log( $(this).parents('[is_edit_block=true] [class*=col-xs-]'));
            console.log( $(this).parents('[is_edit_block=true] .row'));
            console.log(allParentContainerDom);
        }
        $($('.containerShow>iframe')[0].contentDocument).find('body').on('click','[is_edit_block=true] [class*=col-xs-]',function(event){
            showAllParentDomNav.call(this);
            if($(this).is('.append>.col-xs-12')){ //增加元素
                $(this).parent().removeClass('append');
                $(this).html('');
                $(this).parent().before($('<div class="row append"><div class="col-xs-12">+</div></div>'));
                $(this).parent().after($('<div class="row append"><div class="col-xs-12">+</div></div>'));
                event.stopPropagation();
            }else{
                clearTemp();
                if(    $(this).is('.col-xs-12')   ){
                    var domTemp = this.parentNode;
                }else{
                    var domTemp = this;
                }
                $(domTemp).addClass('on');
                if($(domTemp).find('>div').is('.row')){
                    selectBlock(domTemp,1);
                }else if($(domTemp).find('>div').is('[class*=col-xs-]')){
                    selectBlock(domTemp,2);
                }else{
                    selectBlock(domTemp,3);
                }
                event.stopPropagation();
            }
        });
        function selectRow(event){
            clearTemp();
            $(this).addClass('on');
            if($(this).find('>div').is('.row')){
                selectBlock(this,1);
            }else if($(this).find('>div').is('[class*=col-xs-]')){
                selectBlock(this,2);
            }else{
                selectBlock(this,3);
            }
            event.stopPropagation();
        }
        $($('.containerShow>iframe')[0].contentDocument).find('body').on('click','[is_edit_block=true] .row',function(event){
            showAllParentDomNav.call(this);
            selectRow(event);
        });
        $($('.containerShow>iframe')[0].contentDocument).find('body').on('click','[is_edit_block=true]',function(event){
            showAllParentDomNav.call(this);
            selectRow(event);
        });
        $($('.containerShow>iframe')[0].contentDocument).find('body').on('click','.container .row[class*=on] .append',function(event){
            var maxWidth = 0;
            var maxDom = null;
            $(this).parent().find('>[class*=col-xs-]').each(function(){
                var tmp = parseInt($(this).attr('class').match(/col-xs-(\d+)/)[1]);
                if(tmp>maxWidth){
                    maxWidth = tmp;
                    maxDom = this;
                }
            });
            $(maxDom).removeClass('col-xs-'+maxWidth);
            $(maxDom).addClass('col-xs-'+(maxWidth-parseInt(maxWidth/2)));
            $(this).removeClass('append').addClass('col-xs-'+parseInt(maxWidth/2));
            $(this).parent().before($('<div class="append"><span>+</span></div>'));
            $(this).parent().after($('<div class="append"><span>+</span></div>'));
            $(this).html('');
        });
        $('.deleteAppend').click(function(){
            var On = $($('.containerShow>iframe')[0].contentDocument).find('body .on');
            if(On.is('[class*=col-xs-]')){
                var myWidth = parseInt(On.attr('class').match(/col-xs-(\d+)/)[1]);
                var next = On.next();
                if(next.length>0){
                    var nextWidth = parseInt(On.next().attr('class').match(/col-xs-(\d+)/)[1]);
                    On.next().removeClass('col-xs-'+nextWidth);
                    On.next().addClass('col-xs-'+(nextWidth+myWidth));
                    On.remove();
                }else{
                    var prevWidth = parseInt(On.prev().attr('class').match(/col-xs-(\d+)/)[1]);
                    On.prev().removeClass('col-xs-'+prevWidth);
                    On.prev().addClass('col-xs-'+(prevWidth+myWidth));
                    On.remove();
                }
            }
        });
        $('.containerShow').click(function(){
            clearTemp();
            $(this).find('>.container').addClass('on');
            selectBlock($(this).find('>.container')[0],1);
            event.stopPropagation();
        });
        $('#tmpChangeContainerAdmin').click(function(){
            clearTemp();
        });
    })();
</script>