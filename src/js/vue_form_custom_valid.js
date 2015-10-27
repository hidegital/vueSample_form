var Vue = require("vue");
var app = new Vue({
    // element to mount to
    el: '#app',
    // initial data
    data: {
        newEvent: {
            title: '',
            description: '',
            date: '',
            location: ''
        },
        validation: {
            title: false,
            description: false,
            date: false,
            location: false
        }
    },
    // validation
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
        }
    },
    // computed property for form validation state
    computed: {
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
        },
    }
})
