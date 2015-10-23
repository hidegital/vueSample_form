<style>
    .sample {
        width: 280px;
        border: 1px solid #eee;
    }
    .sample .title {
        font-weight: bold;
        font-size: 24px;
    }
    .sample .body {
        padding: 8px 0;
        text-align: center;
    }
</style>

<template>

</template>

<script>
module.exports = {
    data: function () {
        return {
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
        };
    }
};
</script>
