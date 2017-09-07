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
        .body_i {
            width: 70%;margin: 90px auto;
        }
    </style>
    <div class="body_i">
        <form action="/register.html" method="post">
            <input type="hidden" name="action" value="regist">
            <div>{if !empty($msgWrong)}<span style="color:#b45e57;">{$msgWrong}</span>{/if}</div>
            <div class="form-group">
                <label for="exampleInputEmail1">邮箱</label>
                <input type="email" name="email" class="form-control" placeholder="邮箱">
            </div>
            <div class="form-group">
                <label for="exampleInputPassword1">密码</label>
                <input type="password" name="password" class="form-control" placeholder="密码">
            </div>
            <div class="form-group">
                <label for="exampleInputPassword1">再次输入密码</label>
                <input type="password" name="passwordAgain" class="form-control" placeholder="再次输入密码">
            </div>
            <div class="form-group verifyCode" style="display: none;">
                <label for="exampleInputPassword1">验证码</label>
                <input type="password" name="verifyCode" class="form-control">
            </div>
            <div class="checkbox" name="ok">
                <label>
                    <input type="checkbox">本人同意并准守此条款
                </label>
            </div>
            <div>
                <button type="submit" class="btn btn-default">注册</button>
            </div>
        </form>
        <script>
            $("[name=passwordAgain]").on("input propertychange",function(){
                if($(this).val()==$("[name=password]").val()){
                    if($('.verifyCode').find('img').length==0){
                        $('.verifyCode').show();
                        $('.verifyCode').append('<img src="register.html?action=getVerify"/>');
                    }
                }
            });
            $('form').submit(function(){
                if(!$('[name=email]').val().match(/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+$/)){
                    alert('请输入正确的邮箱地址');return false;
                }
                if($('[name=password]').val()==''){
                    alert('请设置密码');return false;
                }
                if( $('[name=password]').val() !== $('[name=passwordAgain]').val() ){
                    alert('两次密码必须一致');return false;
                }
                if($('[name=password]').val().length<=8){
                    alert('密码请大于8位');return false;
                }
                if(!$('[name=ok] [type=checkbox]').is(":checked")){
                    alert('请同意服务条款');return false;
                }
            });
        </script>
    </div>
{/block}