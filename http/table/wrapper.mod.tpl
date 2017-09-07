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
            if($('#tablePanel').is('.edit')){
                $(wrap).find('ul').html('');
                var allRightButton = [];
                var activeDom = null;
                {/literal}
                {include file="table/rightButton.modjs.js"}
                {literal}
                for(var i in allRightActionConfig){
                    if($(e.target).is(i) || $(e.target).parents(i).length>0){
                        if($(e.target).is(i)){
                            activeDom = e.target;
                        }else{
                            activeDom = $(e.target).parents(i)[0]
                        }
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
                        var li = $('<li data-action="'+allRightButton[i].action+'">'+allRightButton[i].title+'</li>');
                        li[0].activeDom = activeDom;
                        $(wrap).find('ul').append(li);
                    }
                }
                var e = event || window.event;
                wrap.style.display = 'block';
                wrap.style.left = e.pageX+'px';
                wrap.style.top = (e.pageY) +'px';
                if(allRightButton.length>0){
                    return false;//取消右键点击的默认事件
                }
            }
        };
        document.onclick= function(){
            wrap.style.display = 'none';
        }
    };
    {/literal}
    $('#wrapper').on('click','>ul>li',function(){
        {include file="table/rightButton.modjs.js"}
        allRightAction[$(this).data('action')].call(this.activeDom);
    });

    $('.allCharts').append()
</script>