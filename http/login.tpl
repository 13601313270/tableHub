{extends file='template/main.layout.tpl'}
{block name="nav"}
<style>
    .nav_i {
        margin: 0 -15px;
        position: relative;
        padding: 40px 0;
        color: #fff;
        text-align: center;
        text-shadow: 0 1px 3px rgba(0, 0, 0, .4), 0 0 30px rgba(0, 0, 0, .075);
        background: #020031;
        background: -webkit-gradient(linear, left bottom, right top, color-stop(0, #020031), color-stop(100%, #6d3353));
        background: -webkit-linear-gradient(45deg, #020031 0, #6d3353 100%);
        background: -o-linear-gradient(45deg, #020031 0, #6d3353 100%);
        background: linear-gradient(45deg, #020031 0, #6d3353 100%);
        -webkit-box-shadow: inset 0 3px 7px rgba(0, 0, 0, .2), inset 0 -3px 7px rgba(0, 0, 0, .2);
        box-shadow: inset 0 3px 7px rgba(0, 0, 0, .2), inset 0 -3px 7px rgba(0, 0, 0, .2);
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
        width: 70%;
        margin: 90px auto;
    }
</style>
<div class="body_i">
    <form action="/login.html" method="post">
        <h2>登录</h2>
        <p class="message"></p>
        <input type="hidden" name="action" value="login">
        <div>{if !empty($msgWrong)}<span style="color:#b45e57;">{$msgWrong}</span>{/if}</div>
        <div class="form-group">
            <label for="exampleInputEmail1">邮箱</label>
            <input type="email" name="email" class="form-control" placeholder="邮箱">
        </div>
        <div class="form-group">
            <label for="exampleInputPassword1">密码</label>
            <input type="password" name="password" class="form-control" placeholder="密码">
        </div>
        <div class="form-group verifyCode" style="display: none;">
            <label for="exampleInputPassword1">验证码</label>
            <input name="verifyCode" class="form-control">
            <img/>
        </div>
        <div>
            <button type="submit" class="btn btn-default">登录</button>
        </div>
    </form>
    <script>
        {
            literal
        }

        function MD5(sMessage) {
            var type = 32;//md5长度，这个值只被这一个函数使用，所以没必要放在外层作用域里面
            var jsMD5_Typ = type;

            function RotateLeft(lValue, iShiftBits) {
                return (lValue << iShiftBits) | (lValue >>> (32 - iShiftBits));
            }

            function AddUnsigned(lX, lY) {
                var lX4, lY4, lX8, lY8, lResult;
                lX8 = (lX & 0x80000000);
                lY8 = (lY & 0x80000000);
                lX4 = (lX & 0x40000000);
                lY4 = (lY & 0x40000000);
                lResult = (lX & 0x3FFFFFFF) + (lY & 0x3FFFFFFF);
                if (lX4 & lY4)
                    return (lResult ^ 0x80000000 ^ lX8 ^ lY8);
                if (lX4 | lY4) {
                    if (lResult & 0x40000000)
                        return (lResult ^ 0xC0000000 ^ lX8 ^ lY8);
                    else
                        return (lResult ^ 0x40000000 ^ lX8 ^ lY8);
                } else
                    return (lResult ^ lX8 ^ lY8);
            }

            function F(x, y, z) {
                return (x & y) | ((~x) & z);
            }

            function G(x, y, z) {
                return (x & z) | (y & (~z));
            }

            function H(x, y, z) {
                return (x ^ y ^ z);
            }

            function I(x, y, z) {
                return (y ^ (x | (~z)));
            }

            function FF(a, b, c, d, x, s, ac) {
                a = AddUnsigned(a, AddUnsigned(AddUnsigned(F(b, c, d), x), ac));
                return AddUnsigned(RotateLeft(a, s), b);
            }

            function GG(a, b, c, d, x, s, ac) {
                a = AddUnsigned(a, AddUnsigned(AddUnsigned(G(b, c, d), x), ac));
                return AddUnsigned(RotateLeft(a, s), b);
            }

            function HH(a, b, c, d, x, s, ac) {
                a = AddUnsigned(a, AddUnsigned(AddUnsigned(H(b, c, d), x), ac));
                return AddUnsigned(RotateLeft(a, s), b);
            }

            function II(a, b, c, d, x, s, ac) {
                a = AddUnsigned(a, AddUnsigned(AddUnsigned(I(b, c, d), x), ac));
                return AddUnsigned(RotateLeft(a, s), b);
            }

            function ConvertToWordArray(sMessage) {
                var lWordCount;
                var lMessageLength = sMessage.length;
                var lNumberOfWords_temp1 = lMessageLength + 8;
                var lNumberOfWords_temp2 = (lNumberOfWords_temp1 - (lNumberOfWords_temp1 % 64)) / 64;
                var lNumberOfWords = (lNumberOfWords_temp2 + 1) * 16;
                var lWordArray = Array(lNumberOfWords - 1);
                var lBytePosition = 0;
                var lByteCount = 0;
                while (lByteCount < lMessageLength) {
                    lWordCount = (lByteCount - (lByteCount % 4)) / 4;
                    lBytePosition = (lByteCount % 4) * 8;
                    lWordArray[lWordCount] = (lWordArray[lWordCount] | (sMessage.charCodeAt(lByteCount) << lBytePosition));
                    lByteCount++;
                }
                lWordCount = (lByteCount - (lByteCount % 4)) / 4;
                lBytePosition = (lByteCount % 4) * 8;
                lWordArray[lWordCount] = lWordArray[lWordCount] | (0x80 << lBytePosition);
                lWordArray[lNumberOfWords - 2] = lMessageLength << 3;
                lWordArray[lNumberOfWords - 1] = lMessageLength >>> 29;

                return lWordArray;
            }

            function WordToHex(lValue) {
                var WordToHexValue = "", WordToHexValue_temp = "", lByte, lCount;
                for (lCount = 0; lCount <= 3; lCount++) {
                    lByte = (lValue >>> (lCount * 8)) & 255;
                    WordToHexValue_temp = "0" + lByte.toString(16);
                    WordToHexValue = WordToHexValue + WordToHexValue_temp.substr(WordToHexValue_temp.length - 2, 2);
                }
                return WordToHexValue;
            }

            var x = Array();
            var k, AA, BB, CC, DD, a, b, c, d
            var S11 = 7, S12 = 12, S13 = 17, S14 = 22;
            var S21 = 5, S22 = 9, S23 = 14, S24 = 20;
            var S31 = 4, S32 = 11, S33 = 16, S34 = 23;
            var S41 = 6, S42 = 10, S43 = 15, S44 = 21;
            // Steps 1 and 2. Append padding bits and length and convert to words
            x = ConvertToWordArray(sMessage);
            // Step 3. Initialise
            a = 0x67452301;
            b = 0xEFCDAB89;
            c = 0x98BADCFE;
            d = 0x10325476;
            // Step 4. Process the message in 16-word blocks
            for (k = 0; k < x.length; k += 16) {
                AA = a;
                BB = b;
                CC = c;
                DD = d;
                a = FF(a, b, c, d, x[k + 0], S11, 0xD76AA478);
                d = FF(d, a, b, c, x[k + 1], S12, 0xE8C7B756);
                c = FF(c, d, a, b, x[k + 2], S13, 0x242070DB);
                b = FF(b, c, d, a, x[k + 3], S14, 0xC1BDCEEE);
                a = FF(a, b, c, d, x[k + 4], S11, 0xF57C0FAF);
                d = FF(d, a, b, c, x[k + 5], S12, 0x4787C62A);
                c = FF(c, d, a, b, x[k + 6], S13, 0xA8304613);
                b = FF(b, c, d, a, x[k + 7], S14, 0xFD469501);
                a = FF(a, b, c, d, x[k + 8], S11, 0x698098D8);
                d = FF(d, a, b, c, x[k + 9], S12, 0x8B44F7AF);
                c = FF(c, d, a, b, x[k + 10], S13, 0xFFFF5BB1);
                b = FF(b, c, d, a, x[k + 11], S14, 0x895CD7BE);
                a = FF(a, b, c, d, x[k + 12], S11, 0x6B901122);
                d = FF(d, a, b, c, x[k + 13], S12, 0xFD987193);
                c = FF(c, d, a, b, x[k + 14], S13, 0xA679438E);
                b = FF(b, c, d, a, x[k + 15], S14, 0x49B40821);
                a = GG(a, b, c, d, x[k + 1], S21, 0xF61E2562);
                d = GG(d, a, b, c, x[k + 6], S22, 0xC040B340);
                c = GG(c, d, a, b, x[k + 11], S23, 0x265E5A51);
                b = GG(b, c, d, a, x[k + 0], S24, 0xE9B6C7AA);
                a = GG(a, b, c, d, x[k + 5], S21, 0xD62F105D);
                d = GG(d, a, b, c, x[k + 10], S22, 0x2441453);
                c = GG(c, d, a, b, x[k + 15], S23, 0xD8A1E681);
                b = GG(b, c, d, a, x[k + 4], S24, 0xE7D3FBC8);
                a = GG(a, b, c, d, x[k + 9], S21, 0x21E1CDE6);
                d = GG(d, a, b, c, x[k + 14], S22, 0xC33707D6);
                c = GG(c, d, a, b, x[k + 3], S23, 0xF4D50D87);
                b = GG(b, c, d, a, x[k + 8], S24, 0x455A14ED);
                a = GG(a, b, c, d, x[k + 13], S21, 0xA9E3E905);
                d = GG(d, a, b, c, x[k + 2], S22, 0xFCEFA3F8);
                c = GG(c, d, a, b, x[k + 7], S23, 0x676F02D9);
                b = GG(b, c, d, a, x[k + 12], S24, 0x8D2A4C8A);
                a = HH(a, b, c, d, x[k + 5], S31, 0xFFFA3942);
                d = HH(d, a, b, c, x[k + 8], S32, 0x8771F681);
                c = HH(c, d, a, b, x[k + 11], S33, 0x6D9D6122);
                b = HH(b, c, d, a, x[k + 14], S34, 0xFDE5380C);
                a = HH(a, b, c, d, x[k + 1], S31, 0xA4BEEA44);
                d = HH(d, a, b, c, x[k + 4], S32, 0x4BDECFA9);
                c = HH(c, d, a, b, x[k + 7], S33, 0xF6BB4B60);
                b = HH(b, c, d, a, x[k + 10], S34, 0xBEBFBC70);
                a = HH(a, b, c, d, x[k + 13], S31, 0x289B7EC6);
                d = HH(d, a, b, c, x[k + 0], S32, 0xEAA127FA);
                c = HH(c, d, a, b, x[k + 3], S33, 0xD4EF3085);
                b = HH(b, c, d, a, x[k + 6], S34, 0x4881D05);
                a = HH(a, b, c, d, x[k + 9], S31, 0xD9D4D039);
                d = HH(d, a, b, c, x[k + 12], S32, 0xE6DB99E5);
                c = HH(c, d, a, b, x[k + 15], S33, 0x1FA27CF8);
                b = HH(b, c, d, a, x[k + 2], S34, 0xC4AC5665);
                a = II(a, b, c, d, x[k + 0], S41, 0xF4292244);
                d = II(d, a, b, c, x[k + 7], S42, 0x432AFF97);
                c = II(c, d, a, b, x[k + 14], S43, 0xAB9423A7);
                b = II(b, c, d, a, x[k + 5], S44, 0xFC93A039);
                a = II(a, b, c, d, x[k + 12], S41, 0x655B59C3);
                d = II(d, a, b, c, x[k + 3], S42, 0x8F0CCC92);
                c = II(c, d, a, b, x[k + 10], S43, 0xFFEFF47D);
                b = II(b, c, d, a, x[k + 1], S44, 0x85845DD1);
                a = II(a, b, c, d, x[k + 8], S41, 0x6FA87E4F);
                d = II(d, a, b, c, x[k + 15], S42, 0xFE2CE6E0);
                c = II(c, d, a, b, x[k + 6], S43, 0xA3014314);
                b = II(b, c, d, a, x[k + 13], S44, 0x4E0811A1);
                a = II(a, b, c, d, x[k + 4], S41, 0xF7537E82);
                d = II(d, a, b, c, x[k + 11], S42, 0xBD3AF235);
                c = II(c, d, a, b, x[k + 2], S43, 0x2AD7D2BB);
                b = II(b, c, d, a, x[k + 9], S44, 0xEB86D391);
                a = AddUnsigned(a, AA);
                b = AddUnsigned(b, BB);
                c = AddUnsigned(c, CC);
                d = AddUnsigned(d, DD);
            }
            var TypNN;
            if (jsMD5_Typ == '16') {
                TypNN = WordToHex(b) + WordToHex(c);
            }
            if (jsMD5_Typ == '32') {
                TypNN = WordToHex(a) + WordToHex(b) + WordToHex(c) + WordToHex(d);
            }
            return TypNN;
        }

        {
            /literal}
            $('[name=email]').on('keyup paste', function() {
                $('.verifyCode img').attr('src', '');
                $('.verifyCode').hide();
            });
            $('[name=password]').on('keyup paste', function() {
                $('.verifyCode img').attr('src', '');
                $('.verifyCode').hide();
            });
            $('.verifyCode img').click(function() {
                $('.verifyCode img').attr('src', 'login.html?action=getVerify&user=' + $('[name=email]').val() + '&_=' + (new Date()).getTime());
            });
            $('form').submit(function() {
                if (!$('[name=email]').val().match(/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+$/)) {
                    alert('请输入正确的邮箱地址');
                    return false;
                }
                if ($('[name=password]').val() == '') {
                    alert('请输入密码');
                    return false;
                }
                if ($('.verifyCode img').attr('src') == '') {
                    $('.verifyCode').show();
                    $('.verifyCode img').attr('src', 'login.html?action=getVerify&user=' + $('[name=email]').val() + '&_=' + (new Date()).getTime());
                    return false;
                } else {
                    $.get('login.html', {
                        action: 'getRegisterToken',
                        email: $('[name=email]').val(),
                        verify: $('[name=verifyCode]').val()
                    }, function(data) {
                        if (data) {
                            data = JSON.parse(data);
                            $.post('login.html', {
                                action: 'login',
                                email: $('[name=email]').val(),
                                password: MD5(MD5($('[name=password]').val() + data.registerToken) + data.registerToken + data.loginToken)
                            }, function(data) {
                                document.cookie = 'sessionToken=' + data + ';path=/';
                                location.href = 'http://www.tablehub.cn/list/'
                            });
                        } else {
                            $('.message').html('验证码输入错误');
                            $('.verifyCode').show();
                            $('.verifyCode img').attr('src', 'login.html?action=getVerify&user=' + $('[name=email]').val() + '&_=' + (new Date()).getTime());
                        }
                    });
                    return false;
                }
            });
    </script>
</div>
{/block}