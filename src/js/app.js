var ua           = require('./ua.js'),
    resizeMargin = require('./resizeMargin.js'),
    nav          = require('./nav.js')

var userAgent = window.navigator.userAgent.toLowerCase();

console.log('ddd');
console.log('ccc');


var Vue = require("vue");
var validator = require("vue-validator");

Vue.use(validator);

var vueSample = require("../vue/sample.vue");

var app = module.exports = new Vue({

    el: '#app',
    // 自分の配下で使用するコンポーネント（<vue-sample>）を定義
    components: {
        "vue-sample": vueSample
    },

    data: {
        items: []
    },

    created: function() {
        // ダミーデータをセット
        this.items.push({
            "title": "hoge",
            "logo": "https://connpass-tokyo.s3.amazonaws.com/thumbs/de/dc/dedc44c50713733d06b9121186469c18.png",
            "url":"http://hogehoge/",
            "description": "hogehoge"
        });
        this.items.push({
            "title": "fuga",
            "logo": "https://connpass-tokyo.s3.amazonaws.com/thumbs/de/dc/dedc44c50713733d06b9121186469c18.png",
            "url":"http://fugafuga/",
            "description": "fugafuga"
        });
    }
});




