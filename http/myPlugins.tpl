{extends file='template/main.layout.tpl'}
{block name="nav"}

{/block}
{block name=body}
    <style>
        {literal}
        .body_i{
            width:100%;min-height:500px;margin: 15px auto;
        }
        .body_i:after{
            display: block;
            content: '';
            clear: both;
        }
        .body_i .panel{float: left;margin: 0 5px 20px 5px;height: 200px;}

        @media screen and (min-width: 1200px) {
            #dataAdmin{width:1040px;}
            #dataAdmin .panel{width: 250px;}
        }
        @media screen and (min-width: 900px) and (max-width: 1199px){
            #dataAdmin{width:840px;}
            #dataAdmin .panel{width: 200px;}
        }
        @media screen and (min-width: 700px) and (max-width: 899px){
            #dataAdmin{width:640px;}
            #dataAdmin .panel{width: 200px;}
        }
        @media screen and (min-width: 550px) and (max-width: 699px){
            #dataAdmin{width:480px;}
            #dataAdmin .panel{width: 230px;}
        }
        @media screen and (max-width: 549px){
            #dataAdmin{width:90%;}
            #dataAdmin .panel{width: 100%;margin: 0 0 20px;}
        }
        {/literal}
    </style>
    <div class="body_i">
        <script>
            $(function(){
                $(document).on({
                    dragleave:function(e){
                        e.preventDefault();
                    },
                    drop:function(e){
                        e.preventDefault();
                    },
                    dragenter:function(e){
                        e.preventDefault();
                    },
                    dragover:function(e){
                        e.preventDefault();
                    }
                });
                window.addEventListener("drop",function(e){
                    var fileName = prompt('请输入文件名');
                    if(fileName!==null){
                        e.preventDefault();
                        var fileList = e.dataTransfer.files;
                        var xhr = new XMLHttpRequest();
                        xhr.onreadystatechange = function(){
                            if (xhr.readyState==4 && xhr.status==200){
//                                location.href = location.href;
                            }
                        };
                        xhr.open("post", '/list/', true);
                        xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
                        var fd = new FormData();
                        fd.append('action','upFile');
                        fd.append('fileName',fileName);
                        fd.append('file', fileList[0]);
                        xhr.send(fd);
                    }
                },false);
            });
        </script>
        {foreach $fileList as $k=>$v}
            <a href="http://www.tablehub.cn/table/{$v.id}.html">
                <div class="panel panel-default">
                    <div class="panel-heading">{$v.title}</div>
                    <div class="panel-body">
                        <p>创建于2017-07-14 01:09:41</p>
                    </div>
                </div>
            </a>
        {/foreach}
    </div>
{/block}