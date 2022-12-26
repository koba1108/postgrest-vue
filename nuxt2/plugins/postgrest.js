import Vue from 'vue'
import Postgrest from 'vue-postgrest'

Vue.use(Postgrest, {
  apiRoot: 'http://localhost:3000/'
})
