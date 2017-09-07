{extends file='template/main.layout.tpl'}
{block name="nav"}
{/block}
{block name=body}
    <style>
        {literal}
        @font-face {
            font-family: 'iconfont';  /* project id 384848 */
            src: url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.eot');
            src: url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.eot?#iefix') format('embedded-opentype'),
            url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.woff') format('woff'),
            url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.ttf') format('truetype'),
            url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.svg#iconfont') format('svg');
        }
        .body_i{
            width:100%;min-height:500px;margin: 15px auto;
        }
        .body_i:after{
            display: block;
            content: '';
            clear: both;
        }
        .body_i .panel{
            float: left;margin: 0 5px 20px 5px;height: 200px;
        }

        @media screen and (min-width: 1200px) {
            .body_i{width:1040px;}
            .body_i .panel{width: 250px;}
        }
        @media screen and (min-width: 900px) and (max-width: 1199px){
            .body_i{width:840px;}
            .body_i .panel{width: 200px;}
        }
        @media screen and (min-width: 700px) and (max-width: 899px){
            .body_i{width:640px;}
            .body_i .panel{width: 200px;}
        }
        @media screen and (min-width: 550px) and (max-width: 699px){
            .body_i{width:480px;}
            .body_i .panel{width: 230px;}
        }
        @media screen and (max-width: 549px){
            .body_i{width:90%;}
            .body_i .panel{width: 100%;margin: 0 0 20px;}
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
        <style>
            .addExcel{
                background-color: #dce4e4;
            }
            .addExcel:hover{
                background-color: #c6cdcd;
            }
            .addExcel>div{
                cursor:pointer;padding: 15px;font-family:iconfont;text-align:center;height: 157px;line-height: 50px;
            }
        </style>
        <div class="addExcel panel panel-default">
            <div class="panel-body">
                <p style="font-size: 20px;">点击新建表格</p>
                <p style="font-size: 40px;">&#xe641;</p>
            </div>
        </div>
        <script>
            $('.addExcel').click(function(){
                var fileName = prompt('请输入文件名');
                if(fileName!==null){
                    $.post('',{
                        action:'createEmpty',
                        fileName:fileName,
                    },function(data){
                        location.href = location.href;
                    });
                }
            });
        </script>

    </div>
{/block}