var Vue = require("vue");
var app = module.exports = new Vue({
    el: "#app",
    data: {
        newEvent: {
            title: '',
            description: '',
            date: '',
            location: '',
            check: ''
        },
        validation: {
            title: false,
            description: false,
            date: false,
            location: false,
            check: false
        }
    },
    filters: {
        titleValidator: {
            write: function (val) {
                this.validation.title = !!val
                return val
            }
        },
        descriptionValidator: {
            write: function (val) {
                this.validation.description = !!val
                return val
            }
        },
        dateValidator: {
            write: function (val) {
                this.validation.date = !!val
                return val
            }
        },
        locationValidator: {
            write: function (val) {
                this.validation.location = !!val
                return val
            }
        },
        checkValidator: {
            write: function (val) {
                this.validation.check = !!val
                return val
            }
        }
    },
    //computed: {
    //    nameErrors: function() {
    //        return this.name ? []: ['名前は必須です'];
    //    },
    //    zipCodeErrors: function() {
    //        return /[0-9]{7}/.test(this.zipCode) ? [] : ['郵便番号(7桁 ハイフン無し)で入力して下さい'];
    //    },
    //    prefectureErrors: function() {
    //        this.prefecture === '0' ? ['都道府県を選択して下さい'] : [];
    //    },
    //    errors: function() {
    //        return [].concat(this.nameErrors, this.zipCodeErrors, this.prefectureErrors);
    //    },
    //    valid: function() { return !errors.length; }
    //},
    // computed property for form validation state
    computed: {
        //titleValidator: {
        //    write: function (val) {
        //        this.validation.title = !!val
        //        return val
        //    }
        //},
        isValid: function () {
            var valid = true
            for (var key in this.validation) {
                if (!this.validation[key]) {
                    valid = false
                }
            }
            return valid
        }
    },
    // methods
    methods: {
        addEvent: function (e) {
            e.preventDefault()
            if (this.isValid) {
                console.log("success")
            }else{
                console.log("need edit")
            }
        }
    }
});

