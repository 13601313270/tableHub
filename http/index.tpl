{extends file='template/main.layout.tpl'}
{block name="nav"}
    <style>
        .nav_i{
            margin: 0 -15px;
            position: relative;
            padding: 40px 0;
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
    </style>
    <div class="nav_i">
        <h1>tablehub.cn</h1>
        <h2>利于共享,数据绑定</h2>
    </div>
{/block}
{block name=body}
    <style>
        .body_i{
            text-align: center;
        }
        .body_i p{
            width: 80%;
            margin: 20px auto;
            font-size: 21px;
        }
        .body_i>.row{
            padding: 20px 0;
            border-bottom: solid 1px #e8e8e8;
        }
        .login>div{
            width: 140px;
            margin: 40px auto;
            padding: 10px 15px;
            border-radius: 5px;
            color: #6f5499;
            font-size: 20px;
            border: solid 1px #6f5499;
        }
        .login>div:hover{
            background-color: #6f5499;
            color:white;
        }
        .login{
            color: #6f5499;
            text-decoration:none;
        }
        .login:hover{
            text-decoration:none;
        }
    </style>
    <div class="body_i">
        <div class="row">
            <h2>修改后同步</h2>
            <div class="col-xs-6">
                <h2>传统电子表格</h2>
                <h3>邮件或qq传递</h3>
                <p>每次改动，都要qq传送，或者邮件发送给相关人。多人协作制作一个表格，更是天方夜谭。</p>
            </div>
            <div class="col-xs-6">
                <h2>tablehub</h2>
                <h3>浏览器刷新自动更新</h3>
                <p>只需将连接分享给相关人，以后你的每次修改后，打开对应链接自动更改，更可通过权限配置，让更多相关人同时制作同一个表格。</p>
            </div>
        </div>
        <div class="row">
            <h2>数据来源</h2>
            <div class="col-xs-6">
                <h2>传统电子表格</h2>
                <h3>ctrl+c，ctrl+v小能手</h3>
                <p>需要从各种后台粘贴数据，才能形成表格内容，每日繁琐的日常很容易出错。</p>
            </div>
            <div class="col-xs-6">
                <h2>tablehub</h2>
                <h3>自动绑定</h3>
                <p>可以通过配置，直接请求接口，内容自动填充，让你把精力放在大数据分析上。</p>
            </div>
        </div>
        <div class="row">
            <h2>使用方式</h2>
            <div class="col-xs-6">
                <h2>传统电子表格</h2>
                <h3>软件安装</h3>
                <p>必须安装excel或者wps软件才可使用</p>
            </div>
            <div class="col-xs-6">
                <h2>tablehub</h2>
                <h3>浏览器</h3>
                <p>可以直接使用任意现代浏览器就可全功能使用</p>
                <p>(推荐使用chrome)</p>
            </div>
        </div>
        <div class="row">
            <h2>高级编程</h2>
            <div class="col-xs-6">
                <h2>传统电子表格</h2>
                <h3>古董语言vb</h3>
                <p>相信你是第一次听说这门语言,小众的不能再小众</p>
            </div>
            <div class="col-xs-6">
                <h2>tablehub</h2>
                <h3>php或js</h3>
                <p>一拉一大把的主流工程师,复杂的功能再也不是梦</p>
                <p>(只针对付费用户)</p>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12">
                <h2>立即注册</h2>
                <p>tablehub可以<span style="color:rgb(191, 24, 24);">免费</span>使用，通过账号登录后，即可创建您的云端表格。</p>
                <a class="login" href="/register.html"><div>立即注册</div></a>
            </div>
        </div>
    </div>
{/block}