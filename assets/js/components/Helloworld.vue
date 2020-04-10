<template>
    <div class="card">
        <header class="card-header">
            <p class="card-header-title">
                Example Vue.js component
            </p>
        </header>
        <div class="card-content">
            <div class="content">
                Message: <strong>{{ message.length > 0 ? message : 'none' }}</strong>
            </div>
        </div>
        <footer class="card-footer">
            <div class="field">
                <label class="label" for="inputMessage">Message</label>
                <div class="control has-icons-left has-icons-right">
                    <input v-model="message" class="input" id="inputMessage" type="text" placeholder="Enter a message..." autofocus>
                    <span class="icon is-small is-left">
                        <i class="far fa-comment-dots"></i>
                    </span>
                </div>
            </div>
        </footer>
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
</style>
