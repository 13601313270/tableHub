<template>
    <div :style="css"
         @mousedown.self.prevent="mousedown($event)">
        <slot></slot>
    </div>
</template>

<script>
    export default {
        props: {
            'move': {default: 'both'}
        },
        data() {
            return {
                mDown: false, downX: 0, downY: 0, positionX: null, positionY: null,
            };
        },
        computed: {
            css() {
                return {
                    zIndex: 99,
                    left: this.positionX === null ? '' : (this.positionX + 'px'),
                    top: this.positionY === null ? '' : (this.positionY + 'px'),
                }
            }
        },
        methods: {
            mousedown(event) {
                if (this.positionX === null) {
                    this.positionX = event.target.offsetLeft;
                    this.positionY = event.target.offsetTop;
                }
                this.mDown = true;
                this.downX = event.target.offsetLeft - event.pageX;
                this.downY = event.target.offsetTop - event.pageY;
                document.addEventListener("mousemove", this.mousemove);
                document.addEventListener("mouseup", this.mouseup);
                event.preventDefault();
            },
            mouseup(event) {
                this.mDown = false;
                document.removeEventListener("mousemove", this.mousemove);
                document.removeEventListener("mouseup", this.mouseup);
                this.$emit('mouseup', {x: this.positionX, y: this.positionY, dom: this.$el})
                event.preventDefault();
            },
            mousemove(event) {
                if (this.mDown) {
                    if (['x', 'both'].includes(this.move)) {
                        this.positionX = this.downX + event.pageX;
                    }
                    if (['y', 'both'].includes(this.move)) {
                        this.positionY = this.downY + event.pageY;
                    }
                    this.$emit('mousemove', {x: this.positionX, y: this.positionY, dom: this.$el})
                    event.preventDefault();
                }
            },
        }
    }
</script>

<style lang="less" scoped>
    .width-move {
    }
</style>