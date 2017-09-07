<style>
    .head{
        height: 50px;
        line-height: 50px;
        font-size: 20px;
        color: #6f5499;
        position: relative;
        border-bottom: solid 1px #ececec;
        font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", sans-serif;
    }
    .head a{
        color: #6f5499;
        text-decoration:none;
    }
    .head>.user{
        float: right;
        text-align: right;
        font-size: 16px;
        color: #6f5499;
        cursor: pointer;
    }
    .head>.user:hover .moveAction{
        display: block;
        opacity: 1;
    }
    .head>.user .moveAction{
        position: absolute;
        opacity: 0;
        display: none;
        transition:all .8s ease .5s;
        -webkit-transition:all .8s ease .5s;
        right: 0;
        z-index: 2;
        border: solid 1px #5f5f5f;
        background-color: #f1f1f1;
        box-shadow: 0 4px 50px 5px rgba(56, 56, 56, 0.33);
    }
    .head>.user .moveAction>a>div{
        line-height: 20px;padding: 5px 10px;
    }
    .head>.user .moveAction>a>div:hover{
        background-color: #e0e0e0;
    }
</style>
<div class="head">
    <a href="/">{$headTitle}</a>
    <div class="user">
        {if $userInfo}
            {$userInfo.userName}
            <div class="moveAction">
                <a href="/list/"><div>我的表格</div></a>
                {*<a href="/plugins/"><div>我的插件</div></a>*}
                <a href="/login.html?logout=true"><div>退出登录</div></a>
            </div>
        {else}
            <a href="login.html">登录</a>|<a href="register.html">注册</a>
        {/if}
    </div>
</div>