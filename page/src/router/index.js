import Vue from 'vue'
import Router from 'vue-router'
import Page from '@/components/page'


Vue.use(Router)

export default new Router({
    routes: [
        {
            path: '/',
            name: 'Hello',
            component: Page
        }, {
            path: '/table/36.html',
            name: 'Hello',
            component: Page
        }
    ]
})
