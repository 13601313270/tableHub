<div class="tab-pane fade" id="modAdmin">
    <style>
        #modAdmin{
            padding-left: 5px;height:129px;overflow-y: scroll;
        }
        #modAdmin>.panel{
            position:relative;width:180px;height:120px;float:left;background-size: auto 89px;background-position-y: 27px;background-repeat: no-repeat;
        }
        #modAdmin>.panel>.panel-body{
            padding: 0!important;position:absolute;z-index: 5;background-color: rgba(255, 255, 255, 0.8);
        }
        #modAdmin>.panel>.ifrPanel{
            pointer-events:none;
            opacity: 0.9;margin-top: 27px;position:absolute;border:none;z-index: 4;transform-origin: top left;
        }
        #modAdmin>.panel>.ifrPanel>iframe{
            border:solid 1px #dbdbdb;
        }
        #modAdmin>.panel:hover{
            position:initial;overflow: inherit;
        }
        #modAdmin>.panel:hover .ifrPanel{
            position:fixed;padding:10px;border:solid 1px black;background-color: white;box-shadow:0 0 40px 10px #616161;z-index: 6;opacity: 1;transform:scale(1)
        }
    </style>
    {foreach $allModule as $mod}
        <div class="panel panel-default" data-name="{$mod.name}" data-type="{$mod.type}" data-html="{htmlspecialchars($mod.html)}">
            <div class="panel-heading">{if isset($mod.title)&&$mod.title!==''}{$mod.title}{else}{$mod.name}{/if}</div>
            <div class="panel-body">
                {foreach $mod.callArgs as $args}
                    <div data-name="{$args.name}" data-default="{$args.default}">{$args.name}:
                        {if isset($args.default)}
                            默认值{$args.default}
                        {else}
                            必填
                        {/if}
                    </div>
                {/foreach}
            </div>
        </div>
    {/foreach}
</div>
<script>
    {literal}
    var modAdminBlock = {
        //验证图片是否存在
        isImgLoad:function(imageUrl,callBack){
            var image = new Image();
            image.onload = function(){
                callBack(true);
            }
            image.onerror = function(){
                callBack(false);
            }
            image.src = imageUrl;
        },
        select:function(callBack){
            $('#modAdmin>.panel').click(function(){
                var returnStr = '';
                if($(this).data('type')=='include'){
                    returnStr += '{include file="'+$(this).data('name')+'.mod.tpl"';
                    $(this).find('>.panel-body>div').each(function(){
                        if($(this).data('default')){
                            returnStr += ' '+$(this).data('name')+"='"+$(this).data('default')+"'";
                        }else{
                            returnStr += ' '+$(this).data('name')+"='*'";
                        }
                    });
                    returnStr+='}';
                }else{
                    returnStr+='<!--modBegin name('+$(this).data('name')+')-->\n'+preLineTextTab+$(this).data('html').replace(/\n/,'\n'+preLineTextTab)+'\n<!--modEnd-->';
                }
                callBack(returnStr);
            });
        }
    };
    $('#modAdmin>.panel').hover(function(){
        var offset = $(this).offset();
        $(this).find('.ifrPanel').css({
            top:offset.top,
            left:offset.left
        });
        var innerBodyWidth = $($(this).find('.ifrPanel iframe')[0].contentDocument).find('body>:not(style)').width();
        var innerBodyHeight = $($(this).find('.ifrPanel iframe')[0].contentDocument).find('body>:not(style)').height();
        if( $(this).find('.ifrPanel iframe').width()<=innerBodyWidth ){
            $(this).find('.ifrPanel iframe').width(innerBodyWidth+2);
            $(this).find('.ifrPanel iframe').height(innerBodyHeight+2);
        }
        $(this).find('.ifrPanel iframe').css({
            transform:('scale(1)')
        });
    },function(){
        $(this).find('.ifrPanel').css({
            top:'',
            left:''
        });
        $(this).find('.ifrPanel iframe').css({
            transform:('scale('+$(this).find('.ifrPanel').data('scale')+')')
        });
    });
    //尝试加载模块的展示图
    $('#modAdmin>div').each(function(){
        var dom = $(this);
        modAdminBlock.isImgLoad('./commonModule/'+dom.data('name')+'.png',function(result){
            if(result==true){
                dom.css('backgroundImage','url(./commonModule/'+dom.data('name')+'.png)');
            }else{
                var ifrPanel = $('<div class="ifrPanel"><iframe></iframe></div>');
                dom.find('.panel-heading').before(ifrPanel);
                $.post('',{
                    action:'runData',
                    tplContent:'<html><head>' +
                    '<link href="//cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">'+
                    '<script src="//cdn.bootcss.com/jquery/3.2.1/jquery.js"><\/script>'+
                    '<script src="//cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"><\/script>'+
                    '<\/head><body style="margin:0">{include file="'+dom.data('name')+'.mod.tpl" iId=1}<\/body><\/html>',
                    phpContent:"<?php include_once('../include.php');$page=new kod_web_page();$page->name='sss';$page->fetch('index.tpl')",
                    simulate:allGet()
                },function(data){
                    try{
                        data = JSON.parse(data);
                        initIframeByHtml(ifrPanel.find('iframe'),data.html);
                        var width = $($(ifrPanel)[0].contentDocument).find('body>:not(style)').css('width');
                        if(parseInt(width)>0){
                            $(ifrPanel).css({
                                transform:('scale('+(parseInt($(ifrPanel).parents('.panel:eq(0)').width())/parseInt(width))+')')
                            });
                            $(ifrPanel).data('scale',(parseInt($(ifrPanel).parents('.panel:eq(0)').width())/parseInt(width)));
                        }
                    }catch (e){

                    }
                });
            }
        });
    });
    {/literal}
</script>