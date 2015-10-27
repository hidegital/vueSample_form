var Vue = require("vue");
var validator = require("vue-validator");
Vue.use(validator);

/*これでよいのだろうか*/
$(function() {
    $('.validation').css('visibility','visible');
});


var app = module.exports = new Vue({
    el: "#app",
    data: {
        id: "",
        password: "",
        email: "",
        emailConfirm: "",
        //name: "",
        //kana: "",
        //tel: "",
        //postalCode: "",
        submitFlg: false,
        checkFlg: {
            id: true,
            password: true,
            mail: true,
            mailConfirm: true
            //name: false,
            //kana: false,
            //tel: false,
            //postalCode: false
        }
    },
    validator: {
        validates: {
            email: function (val) {
                return /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(val)
            },
            match: function (val) {
                return val == this.email;
            },
            zenkakuHiragana: function (val) {
                return /^([ぁ-ん]+)$/.test(val);
            },
            zenkakuKatakana: function (val) {
                return /^([ァ-ヶー]+)$/.test(val);
            },
            hankakuChara: function (val) {
                return /^([a-zA-z¥s]+)$/.test(val);
            },
            keitaiNum: function (val) {
                return /^0¥d0-¥d{4}-¥d{4}$/.test(val);
            },
            postNum: function (val) {
                return /^¥d{3}¥-¥d{4}$/.test(val);
            }
        }
    },
    methods: {
        onCheckId: function () {
            this.checkFlg.id = true;
            if (this.id.length === 0) {
                this.checkFlg.id = false;
            }
        },
        onCheckPass: function () {
            this.checkFlg.password = true;
            if (this.password.length === 0) {
                this.checkFlg.password = false;
            }
        },
        onCheckMail: function () {
            this.checkFlg.mail = true;
            if (this.mail.length === 0) {
                this.checkFlg.mail = false;
            }
        },
        onCheckMailConfirm: function () {
            this.checkFlg.emailConfirm = true;
            if (this.emailConfirm.length === 0) {
                this.checkFlg.emailConfirm = false;
            }
        }
    }
});






