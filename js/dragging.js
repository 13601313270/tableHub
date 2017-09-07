$.fn.extend({
    //---元素拖动插件
    dragging:function(data){
        var $this = $(this);
        var father = $this.parent();
        var defaults = {
            move : 'both',
            hander:1,
            xLimit:true,
            yLimit:true,
            onMousemove:function(dom,pos){
            },
            onMouseup:function(dom){
            }
        }
        var opt = $.extend({},defaults,data);
        var movePosition = opt.move;
        var hander = opt.hander;
        if(hander == 1){
            hander = $this;
        }else{
            hander = $this.find(opt.hander);
        }
        //---初始化
        father.css({"position":"relative"});
        $this.css({"position":"absolute"});
        if(movePosition.toLowerCase() == 'x'){
            hander.css({"cursor":"ew-resize"});
        }else{
            hander.css({"cursor":"move"});
        }
        var faWidth = father.width();
        var faHeight = father.height();
        var thisWidth = $this.width()+parseInt($this.css('padding-left'))+parseInt($this.css('padding-right'));
        var thisHeight = $this.height()+parseInt($this.css('padding-top'))+parseInt($this.css('padding-bottom'));

        var mDown = false;//
        var positionX;
        var positionY;
        hander.mousedown(function(e){
            faWidth = father.width();
            faHeight = father.height();
            father.children().css({"zIndex":"0"});
            $this.moving = true;
            $this.css({"zIndex":"99"});
            mDown = true;
            positionX = $this.position().left-e.pageX;
            positionY = $this.position().top-e.pageY;
            return false;
        });
        $(document).mouseup(function(e){
            mDown = false;
            if($this.moving){
                opt.onMouseup($this);
            }
            $this.moving = false;
        });
        $(document).mousemove(function(e){
            if(mDown){
                var moveObj = {
                };
                if(['x','both'].indexOf(movePosition.toLowerCase())>-1){
                    var moveX = positionX+e.pageX;
                    if(opt.xLimit){
                        if(moveX < 0){
                            moveX = 0;
                        }else if(moveX > (faWidth-thisWidth)){
                            moveX = faWidth-thisWidth;
                        }
                    }
                    moveObj.left = moveX;
                }
                if(['y','both'].indexOf(movePosition.toLowerCase())>-1){
                    var moveY = positionY+e.pageY;
                    if(opt.yLimit){
                        if(moveY < 0){
                            moveY = 0;
                        }else if(moveY > (faHeight-thisHeight)){
//                                    console.log(faHeight);
//                                    console.log(thisHeight);
//                                    console.log(faHeight-thisHeight);
//                                    moveY = faHeight-thisHeight;
                        }
                    }
                    moveObj.top = moveY;
                }
                $this.css(moveObj);
                opt.onMousemove($this,moveObj);
            }
        });
    }
});