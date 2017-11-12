export default function(config) {
    config = Object.assign({
        type: 'GET',
        data: {},
        callbackname: '',
        charset: 'utf-8',
        dataType: '', // [jsonp]
        success: function() {},
        error: function() {}
    },config);
    function jsonToQuery(json) {
        var result = [];
        for(var i in json){
            result.push(i + '=' + json[i]);
        }
        return result.join('&');
    };
    if(config.dataType == 'jsonp'){
        var callbackName = config.callbackname || (
            'video_ajax_callback_' + utils.getRandom());
        var script = doc.createElement('script');
        var head = doc.getElementsByTagName('head')[0] || doc.body;
        window[callbackName] = function(data) {
            config.success(data);
            window[callbackName] = null;
        };
        // 删除节点写在onload事件而不是window[callbackName]内，那样会导致IE6刷新的时候崩溃，诡异
        script.onload = function () {
            script.parentNode.removeChild(script);
        };
        script.charset = config.charset;
        script.async = false;
        config.data.callback = callbackName;
        script.src = config.url + (config.url.indexOf('?') == -1 ? '?' :
            '&') + jsonToQuery(config.data);
        head.insertBefore(script, head.firstChild);
    } else {
        var xhr = new XMLHttpRequest();
        if (config.type !== 'POST') {
            config.url += ((config.url.indexOf('?') == -1 ? '?' :
                '&') + jsonToQuery(config.data));
        }
        if(config['Content-Type']==undefined){
            config['Content-Type'] = "application/json;charset=UTF-8";
        }
        xhr.open(config.type, config.url, true);
        // 必须设置这个头部，不然接受不到数据
        xhr.setRequestHeader("Content-Type",config['Content-Type']);
        xhr.withCredentials = true;
        xhr.onreadystatechange = function() {
            if(xhr.readyState == 4 && xhr.status == 200) {
                try {
                    var res = JSON.parse(xhr.responseText);
                    config.success(res);
                } catch (e) {
                    config.error(e);
                }
            }
        };
        xhr.onerror = function(e) {
            config.error(e);
        }
        if(config.type == 'POST') {
            // xhr.send(JSON.stringify(config.data));
            xhr.send(jsonToQuery(config.data));
        } else {
            xhr.send();
        }
    }

}