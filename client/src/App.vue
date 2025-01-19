<template>
  <div id="app" v-if="loginPass" >
    {{ $t('hello') }}
    <sidenav
    :custom_class="color"
    class="fixed-start"
    v-if="showSidenav"
    />
    <main
      class="main-content position-relative max-height-vh-100 h-100 overflow-x-hidden"
    >
      <AppHeader />


      <div class="content-container">
        <router-view />
      </div>

    </main>
    <notifications />
</div>
<div id="app" v-else>
  <LoginPage />
</div>

</template>
<script>
import Sidenav from "./examples/Sidenav/index.vue";
import { mapMutations, mapState } from "vuex";
import AppHeader from './components/AppHeader.vue';
import {Notifications} from "@kyvg/vue3-notification";
import LoginPage from '@/views/standard/login.vue';

export default {
  name: "App",
  components: {
    Notifications,
    Sidenav,
    AppHeader,
    LoginPage,
  },
  methods: {
    ...mapMutations(["toggleConfigurator", "navbarMinimize","addLoginInfo"]),
  },
  computed: {
    ...mapState([
      "color",
      "isAbsolute",
      "isNavFixed",
      "navbarFixed",
      "absolute",
      "showSidenav",
      "showNavbar",
      "showFooter",
      "showConfig",
      "hideConfigButton",
    ]),
    loginPass() {
      return this.$store.state.loginInfo.name ? true : false;
    },
  },
  data() {
    return {
    };
  },
  mounted() {
    console.log("로그인 상태:", this.loginPass);
    this.$store.state.isTransparent = "bg-transparent";

    const sidenav = document.getElementsByClassName("g-sidenav-show")[0];

    if (window.innerWidth > 1200) {
      sidenav.classList.add("g-sidenav-pinned");
    }
  },
};
</script>
<style>
#app {
  padding-right: 10px;
}
.content-container {
  background-color: #fff;
  margin: 10px 0 10px 0;
  border-radius: 8px;

}
.vue-notification-group {
  width: 400px !important;
  top: 16px !important;
  right: 20px !important;
}

.vue-notification {
  margin: 0 5px 5px;
  padding: 10px;
  font-size: 12px;
  color: $white;

  background: #44a4fc;
  border-left: 5px solid #187fe7;

  &.success {
    background: #68cd86;
    border-left-color: #42a85f;
  }

  &.warn {
    background: #ffb648;
    border-left-color: #f48a06;
  }

  &.error {
    background: #e54d42;
    border-left-color: #b82e24;
  }

  .notification-content {
    font-size: 16px;
  }
}
.grid-container {
  padding: 20px;
  > div {
    height: 300px;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.25);
  }
  &.work {
    .borderTop {
      border-top: 1px solid #6c757d;
      border-bottom: 0 !important;
    }
    .noBorder {
      border: 0 !important;
    }
    .green {
      height: auto;
      margin-top: 6px;
      margin-left: 20px;
      border-radius: 4px;
      padding: 4px 6px;
      width: fit-content !important;
      line-height: 20px;
      font-weight: 900;
      color: white;
      background-color: #4caf50;
    }
    .red {
      height: auto;
      margin-top: 6px;
      margin-left: 20px;
      border-radius: 4px;
      padding: 4px 6px;
      width: fit-content !important;
      line-height: 20px;
      font-weight: 900;
      color: white;
      background-color: #b82e24;
    }
    .gray {
      height: auto;
      margin-top: 6px;
      margin-left: 20px;
      border-radius: 4px;
      padding: 4px 6px;
      width: fit-content !important;
      line-height: 20px;
      font-weight: 900;
      color: white;
      background-color: #6c757d;
    }
  }
}

</style>
