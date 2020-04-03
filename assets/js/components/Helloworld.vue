<template>
    <div>
        <p><b>Example Vue component</b></p>
        <div class="hello-world-styles">
            <p class="hello-world-text">{{ message }}</p>
        </div>
        <input v-model="message" />
    </div>
</template>

<script>
    export default {
        name: "Helloworld",
        data() {
            return {
                message: 'Hello World!'
            }
        }
    }
</script>

<style scoped>
    .hello-world-styles {
        height: 200px;
        width: 200px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        border-style: dotted;
        border-width: 5px;
    }

    .hello-world-text {
        display: inline-block;
        color: red;
    }
</style>
