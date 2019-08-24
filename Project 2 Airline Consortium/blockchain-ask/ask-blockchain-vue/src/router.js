import Vue from 'vue'
import Router from 'vue-router'
import AirlineA from '@/views/AirlineA'
import SecureA from '@/views/SecureA'
import Login from '@/views/Login'
import AirlineB from '@/views/AirlineB'
import SecureB from '@/views/SecureB'
import Admin from '@/views/Admin'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      redirect: {
        name: "login"
      },
      props: true
    },
    {
      path: '/login',
      name: 'login',
      component: Login,
      props: true
    },
    {
      path: '/airlineA',
      name: 'airlineA',
      component: AirlineA,
      props: true
    },
    {
      path: '/airlineB',
      name: 'airlineB',
      component: AirlineB,
      props: true
    },
    {
      path: '/secureA',
      name: 'secureA',
      component: SecureA,
      props: true
    },
    {
      path: '/secureB',
      name: 'secureB',
      component: SecureB,
      props: true
    },
    {
      path: '/Admin',
      name: 'admin',
      component: Admin,
      props: true
    },
    {
      path: '/about',
      name: 'about',
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import(/* webpackChunkName: "about" */ './views/About.vue')
    }
  ]
})
