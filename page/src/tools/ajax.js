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
    function buildParams( prefix, obj, add ) {
        var name;
        if ( Array.isArray( obj ) ) {
            jQuery.each( obj, function( i, v ) {
                var rbracket = /\[\]$/;
                if (rbracket.test( prefix ) ) {

                    // Treat each array item as a scalar.
                    add( prefix, v );

                } else {

                    // Item is non-scalar (array or object), encode its numeric index.
                    buildParams(
                        prefix + "[" + ( typeof v === "object" && v != null ? i : "" ) + "]",
                        v,
                        add
                    );
                }
            } );

        } else if ( jQuery.type( obj ) === "object" ) {

            // Serialize object item.
            for ( name in obj ) {
                buildParams( prefix + "[" + name + "]", obj[ name ], add );
            }

        } else {

            // Serialize scalar item.
            add( prefix, obj );
        }
    }
    function jsonToQuery(obj){
        var prefix,
            s = [],
            add = function( key, value ) {
                s[ s.length ] = encodeURIComponent( key ) + "=" +
                    encodeURIComponent( value == null ? "" : value );
            };

        // If an array was passed in, assume that it is an array of form elements.
        if ( Array.isArray( obj ) || ( obj.jquery && !jQuery.isPlainObject( obj ) ) ) {

            // Serialize the form elements
            jQuery.each( obj, function() {
                add( this.name, this.value );
            } );

        } else {
            for ( prefix in obj ) {
                buildParams( prefix, obj[ prefix ], add );
            }
        }

        // Return the resulting serialization
        return s.join( "&" );
    }
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
        console.log(config.data);
        console.log( jsonToQuery(config.data) );
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