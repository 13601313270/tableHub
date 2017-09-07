<div class="tab-pane fade" id="templateAdmin">
    <style>
        #templateAdmin{
            padding-left: 5px;
        }
        #templateAdmin>div{
            width:180px;height:120px;float:left;background-size: auto 89px;background-position-y: 27px;background-repeat: no-repeat;
        }
        #templateAdmin>div>.panel-body{
            padding-left: 10px;
        }
        #templateAdmin>#tmpChangeAdmin{
            display:none;width:100%;height:100%;position:fixed;top:0;left:0;background-color:rgba(0, 0, 0, 0.5);z-index:3;
        }
        #templateAdmin>.tmpOldBlocks{
            position:absolute;top:30px;left:43%;width: 6.5%;height: 400px;background: white;
        }
        #templateAdmin>.tmpNewBlocks{
            position:absolute;top:30px;left: 50.5%;width: 6.5%;height: 400px;background: white;
        }
        #templateAdmin>.newIframePanel{
            position:absolute;top:30px;left:58%;width: 35%;height: 400px;background: white;
        }
        #templateAdmin>.newIframePanel>div{
            margin: 10px 10px 0 10px;
        }
    </style>
    {foreach $allTemplage as $mod}
        <div class="panel panel-default" data-name="{$mod.name}" data-html="{htmlspecialchars($mod.tplContent)}" style="background-image: url('./metaPHPCacheFile/{$mod.name}.png')">
            <div class="panel-heading">{$mod.name}</div>
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
    <div id="tmpChangeAdmin">
        <div style="position:absolute;top:30px;left:7%;width: 35%;height: 400px;background: white;">
            <iframe id="tmpOld"></iframe>
        </div>
        <div class="tmpOldBlocks" class="ondragover" ondrop="dropEvent.drop(event)" ondragover="dropEvent.allowDrop(event)"><h4>内容</h4></div>
        <div class="tmpNewBlocks"><h4>区域</h4></div>
        <div class="newIframePanel">
            <div>
                <button class="btn btn-default" onclick="tplEditor.setValue(getNewTplContent()),$('#tmpChangeAdmin').hide(),tplEditor.selection.clearSelection()">
                    <span class="glyphicon glyphicon-floppy-saved" aria-hidden="true"></span>迁移
                </button>
                <button class="btn btn-default" onclick="$('#tmpChangeAdmin').hide()">取消</button>
                <button class="btn btn-default setImageCover" onclick="setImage()">设为封面</button>
                <script>
                    $('#tmpChangeAdmin .setImageCover').click(function(){
                        createImageDataByDom($("#templateAdmin>.newIframePanel iframe").contents().find('body'),function(data){
                            $.post('',{
                                action:'saveImg',
                                file:$('#templateAdmin>.newIframePanel iframe').data('id')+'.png',
                                content:data
                            },function(result){
                                if(result==1){
                                    alert('设置成功');
                                }else{
                                    alert('设置失败');
                                }
                            });
                        });
                    });
                </script>
            </div>
            <iframe></iframe>
        </div>
    </div>
</div>
<script>
    {literal}
    var dropEvent = {
        allowDrop:function(ev){
            ev.preventDefault();
        },
        drag:function(ev){
            ev.dataTransfer.setData("Text",ev.target.id);
        },
        drop:function(ev){
            ev.preventDefault();
            var data=ev.dataTransfer.getData("Text");
            if($(ev.target).is('.ondragover')){
                $(ev.target).append($('#'+data));
            }else{
                $(ev.target).parents('.ondragover').append($('#'+data));
            }

            $.post('',{
                action:'runData',
                tplContent:getNewTplContent(),
                phpContent:phpEditor.getValue(),
                tplLine:tplEditor.selection.getRange().start,
                simulate:allGet()
            },function(data){
                data = JSON.parse(data);
                initIframeByHtml($('#templateAdmin>.newIframePanel iframe'),data.html);
                initTplScroll($('#templateAdmin>.newIframePanel iframe'));
            });
        }
    };
    function getNewTplContent(){
        var newTplContent = '{extends file=\''+$('#templateAdmin>.newIframePanel iframe').data('id')+'.layout.tpl\'}';
        $('#templateAdmin>.tmpNewBlocks>div').each(function(){
            newTplContent+='\n{block name='+$(this).data('id')+'}';
            var allChild = $(this).find('>div');
            if(allChild.length>0){
                allChild.each(function(){
                    newTplContent+=$(this).data('html');
                });
            }else{
                newTplContent += '<div style="min-width: 100px;font-size: 30px;border: solid 1px blue;background-color: rgba(0, 135, 255, 0.41);">'+$(this).data('id')+'</div>';
            }
            newTplContent+='{/block}';
        });
        return newTplContent;
    }

    $('#templateAdmin>.panel').click(function(){
        $('#tmpChangeAdmin').show();
        var tplContent = tplEditor.getValue();
        var match = tplContent.match(/^\{extends file='(\S+).layout.tpl'\}\s*(\{block name=[^\}]+\}[\s|\S]*\{\/block\})*$/);
        if(match!==null){
            //替换模板
            var tplFile = match[1];
            var allOldTmpBlockHtmls = match[2].match(/\{block name=[^\}]+\}[\s|\S]*?\{\/block\}/g);
            $('#tmpChangeAdmin .tmpOldBlocks').html('<h4>内容</h4>');
            for(var i=0;i<allOldTmpBlockHtmls.length;i++){
                var temp = allOldTmpBlockHtmls[i].match(/\{block name=(\S+)\}([\s|\S]*?)\{\/block}/);
                var appendDom = $('<div id="blockDrop'+i+'" draggable="true" ondragstart="dropEvent.drag(event)" style="margin: 5px;border: solid 1px #c1c1c1;border-radius: 4px;line-height: 30px;text-align: center;cursor: move;">'+temp[1]+'</div>');
                appendDom.attr('data-html',temp[2]);
                $('#tmpChangeAdmin .tmpOldBlocks').append(appendDom);
            }
            $.post('',{
                action:'runData',
                tplContent:tplContent,
                phpContent:phpEditor.getValue(),
                tplLine:tplEditor.selection.getRange().start,
                simulate:allGet()
            },function(data){
                data = JSON.parse(data);
                initIframeByHtml($('#tmpOld'),data.html);
                initTplScroll($('#tmpOld'));
            });
            $('#templateAdmin>.newIframePanel iframe').attr('data-id',$(this).data('name'));
            var allNewTplContent = $(this).data('html').match(/\{block name=[^\}]+\}[\s|\S]*?\{\/block\}/g);
            $('#templateAdmin>.tmpNewBlocks').html('<h4>区域</h4>');
            for(var i=0;i<allNewTplContent.length;i++){
                var temp = allNewTplContent[i].match(/\{block name=(\S+)\}([\s|\S]*?)\{\/block}/);
                $('#templateAdmin>.tmpNewBlocks').append('<div data-id="'+temp[1]+'" class="ondragover" ondrop="dropEvent.drop(event)" ondragover="dropEvent.allowDrop(event)" style="padding: 2px;margin: 2px;border: solid 1px #a9a7a7;border-radius: 4px;"><h4>'+temp[1]+'</h4></div>');
            }
            $.post('',{
                action:'runData',
                tplContent:getNewTplContent(),
                phpContent:phpEditor.getValue(),
                tplLine:tplEditor.selection.getRange().start,
                simulate:allGet()
            },function(data){
                data = JSON.parse(data);
                initIframeByHtml($('#templateAdmin>.newIframePanel iframe'),data.html);
                initTplScroll($('#templateAdmin>.newIframePanel iframe'));
            });
        }else{
            //原始html改为模板嵌套
        }
    });
    {/literal}
</script>