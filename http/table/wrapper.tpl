<style>
    #wrapper{
        display: none;
        position: absolute;
        background-color: rgba(220, 220, 220, 0.95);
        border-radius: 5px;
        padding: 3px 0px;
        box-shadow: 0px 0px 20px 0px #585858;
    }
    #wrapper>ul{
        margin: 0;
        padding-left: 0;
    }
    #wrapper>ul>li{
        list-style-type: none;
        padding: 0 20px;
    }
    #wrapper>ul>li:hover{
        background-color: #4673d1;
        color:white;
    }
</style>
<div id="wrapper"><ul></ul></div>
<script>
    {literal}
    window.onload = function(){
        var wrap = document.getElementById('wrapper');
        wrap.style.display = 'none';
        var li = document.getElementsByTagName('li');

        for(var i=0;i<li.length;i++){
            li.onmouseover = function(){
                this.classname = "active";
            }
            li.onmouseout = function(){
                this.classname = "";
            }
        }
        document.oncontextmenu = function(e){
            if($('.editChange').is('.openEdit')){
                $(wrap).find('ul').html('');
                var allRightButton = [];
                {/literal}
                {include file="table/rightButton.modjs.js"}
                {literal}
                for(var i in allRightActionConfig){
                    if($(e.target).is(i)){
                        for(var j in allRightActionConfig[i]){
                            allRightButton.push({
                                action:j,
                                title:allRightActionConfig[i][j].title
                            });
                        }
                        $('#wrapper').data('id','lieNum:'+$(e.target).html());
                    }
                }

                if(allRightButton.length>0){
                    for(var i=0;i<allRightButton.length;i++){
                        $(wrap).find('ul').append($('<li data-action="'+allRightButton[i].action+'">'+allRightButton[i].title+'</li>'));
                    }
                }
                var e = event || window.event;
                wrap.style.display = 'block';
                wrap.style.left = e.pageX+'px';
                wrap.style.top = (e.pageY-$('#header').height()) +'px';
                return false;//取消右键点击的默认事件
            }
        };
        document.onclick= function(){
            wrap.style.display = 'none';
        }
    };
    {/literal}
    $('#wrapper').on('click','>ul>li',function(){
        {include file="table/rightButton.modjs.js"}
        var selectId = $('#wrapper').data('id');
        allRightAction[$(this).data('action')](selectId);
    });

    $('.allCharts').append()
</script>