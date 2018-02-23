// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import Vuex from 'vuex';
import App from './App';
import router from './router';
import vuexConfig from './vuex/main';
Vue.use(Vuex);
Vue.config.productionTip = false;

var store = new Vuex.Store(vuexConfig);

/* eslint-disable no-new */
new Vue({
    el: '#app',
    store,
    router,
    template: '<App/>',
    components: {App}
});