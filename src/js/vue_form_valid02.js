var Vue = require("vue");
var app = module.exports = new Vue({
    el: '#form',
    data: {
        name: '',
        zipCode: '',
        prefecture: '0'
    },
    computed: {
        nameErrors: function() {
            return this.name ? []: ['名前は必須です'];
        },
        zipCodeErrors: function() {
            return /[0-9]{7}/.test(this.zipCode) ? [] : ['郵便番号(7桁 ハイフン無し)で入力して下さい'];
        },
        prefectureErrors: function() {
            this.prefecture === '0' ? ['都道府県を選択して下さい'] : [];
        },
        errors: function() {
            return [].concat(this.nameErrors, this.zipCodeErrors, this.prefectureErrors);
        },
        valid: function() { return !errors.length; }
    }
});


