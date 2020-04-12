// Vue example
import Vue from 'vue';
import Helloworld from './components/Helloworld';

new Vue({
    el: '#vue-root',
    components: {
        'hello-world': Helloworld,
    },
});
