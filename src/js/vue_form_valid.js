var Vue = require("vue");
var validator = require("vue-validator");
Vue.use(validator);
var app = module.exports = new Vue({
    el: "#app",
    data: {
        name: "",
        login: "",
        zip: "",
        email: "",
        emailConfirm: ""
    },
    validator: {
        validates: {
            email: function(val){
                return /^(([^<>()[].,;:s@"]+(.[^<>()[].,;:s@"]+)*)|(".+"))@(([[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}])|(([a-zA-Z-0-9]+.)+[a-zA-Z]{2,}))$/.test(val);
            },
            match: function(val, model){
                return val === this[model];
            }
        }
    }
});


