<template>
    <div v-if="hander===null" class="move" :style="css" ref="move"
         @mousedown.prevent="mousedown($event)">
        <slot></slot>
    </div>
    <div v-else class="move" :style="css" ref="move">
        <slot></slot>
    </div>
</template>

<script>
    export default {
        props: {
            'move': {default: 'both'},
            'left': {default: null},
            'top': {default: null},
            'hander': {default: null},
        },
        data() {
            return {
                mDown: false, downX: 0, downY: 0, positionX: this.left, positionY: this.top,
            };
        },
        computed: {
            css() {
                return {
                    position: 'absolute',
                    zIndex: 99,
                    left: this.positionX === null ? '' : (this.positionX + 'px'),
                    top: this.positionY === null ? '' : (this.positionY + 'px'),
                }
            }
        },
        mounted() {
            if (this.$slots.default && this.hander !== null) {
                var className = this.$props.hander;
                this.$slots.default[0].elm.getElementsByClassName(className)[0].addEventListener('mousedown', this.mousedown);
            }
        },
        methods: {
            mousedown(event) {
                if (this.move !== 'none') {
                    if (this.positionX === null) {
                        this.positionX = this.$refs.move.offsetLeft;
                        this.positionY = this.$refs.move.offsetTop;
                    }
                    this.mDown = true;
                    this.downX = this.$refs.move.offsetLeft - event.pageX;
                    this.downY = this.$refs.move.offsetTop - event.pageY;
                    document.addEventListener("mousemove", this.mousemove);
                    document.addEventListener("mouseup", this.mouseup);
                    event.preventDefault();
                }
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
                        // console.log(this.positionX);
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