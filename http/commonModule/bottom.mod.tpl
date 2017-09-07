<style>
    #bottom{
        box-sizing: border-box;
        min-width: 350px;
        height: 130px;
        margin: 0 -15px;
        position: relative;
        padding: 20px 40px;
        color: #fff;
        text-align: center;
        text-shadow: 0 1px 3px rgba(0,0,0,.4), 0 0 30px rgba(0,0,0,.075);
        background: #020031;
        background: -webkit-gradient(linear,left bottom,right top,color-stop(0,#020031),color-stop(100%,#6d3353));
        background: -webkit-linear-gradient(45deg,#020031 0,#6d3353 100%);
        background: -o-linear-gradient(45deg,#020031 0,#6d3353 100%);
        background: linear-gradient(45deg,#020031 0,#6d3353 100%);
        -webkit-box-shadow: inset 0 3px 7px rgba(0,0,0,.2), inset 0 -3px 7px rgba(0,0,0,.2);
        box-shadow: inset 0 3px 7px rgba(0,0,0,.2), inset 0 -3px 7px rgba(0,0,0,.2);
    }
    #bottom>div{
        float: left;height: 40px;line-height: 40px;margin-right: 10px;
    }
    #bottom>div>a{
        color:white;
    }
    #bottom>.line{
        width:100%;
        height:1px;
        background-color: white;
    }
</style>
<div id="bottom">
    <div>友情链接:</div>
    {foreach $fiendLinks as $link}
        <div><a target="_blank" href="{$link[1]}">{$link[0]}</a></div>
    {/foreach}
    <div class="line"></div>
    <div>京ICP备17039360号</div>
</div>