<template>
    <div class="page-float-panel" :style="{left:left_+'px',top:top_+'px'}"
         @mousedown="mousedown($event)"
         @mousemove="mousemove"
         @mouseup="mouseup($event)">
        <div v-if="mDown" class="move-canvas"></div>
        <slot></slot>
    </div>
</template>

<script>
    export default {
        name: "page-float-panel",
        props: ['top', 'left'],
        data() {
            return {
                canMove: true,
                left_: this.left,
                top_: this.top,
                mDown: false,
                moved: false,

                //鼠标点击点
                positionX: 0,
                positionY: 0,
            };
        },
        methods: {
            mousedown(e) {
                if (this.canMove) {
                    this.mDown = true;
                    this.positionX = this.left_ - e.pageX;
                    this.positionY = this.top_ - e.pageY;
                }
                e.preventDefault();
                return false;
            },
            mousemove(e) {
                if (this.mDown) {
                    this.moved = true;
                    let top = this.positionY + e.pageY;
                    let left = this.positionX + e.pageX;
                    if (top < 0) {
                        top = 0
                    }
                    if (left < 0) {
                        left = 0
                    }
                    this.left_ = left;
                    this.top_ = top;
                    this.$emit('move', {
                        top: this.top_,
                        left: this.left_
                    });
                    e.preventDefault();
                }
            },
            mouseup(e) {
                this.mDown = false;
                if (this.moved) {
                    this.moved = false;
                    this.$emit('up', {
                        top: this.top_,
                        left: this.left_
                    });
                    e.preventDefault();
                }
            }
        },
    }
</script>

<style lang="less" scoped>
    .page-float-panel {
        background-color: white;
        position: absolute;
        z-index: 3;
        border: solid 1px #6f6f6f;
        .move-canvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
    }
</style>