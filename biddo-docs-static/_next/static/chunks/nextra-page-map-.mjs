import meta from "../../../pages/_meta.js";
import apps_meta from "../../../pages/apps/_meta.js";
import buy_meta from "../../../pages/buy/_meta.js";
import docs_meta from "../../../pages/docs/_meta.js";
import docs_admin_panel_meta from "../../../pages/docs/admin-panel/_meta.js";
import docs_mobile_app_meta from "../../../pages/docs/mobile-app/_meta.js";
import docs_mobile_app_deploy_meta from "../../../pages/docs/mobile-app/deploy/_meta.js";
import docs_mobile_app_revenue_cat_meta from "../../../pages/docs/mobile-app/revenue-cat/_meta.js";
import docs_server_meta from "../../../pages/docs/server/_meta.js";
import docs_server_tutorials_meta from "../../../pages/docs/server/tutorials/_meta.js";
import docs_web_meta from "../../../pages/docs/web/_meta.js";
import terms_meta from "../../../pages/terms/_meta.js";
export const pageMap = [{
  data: meta
}, {
  name: "apk",
  route: "/apk",
  children: [{
    name: "index",
    route: "/apk",
    frontMatter: {
      "sidebarTitle": "Index"
    }
  }]
}, {
  name: "apps",
  route: "/apps",
  children: [{
    data: apps_meta
  }, {
    name: "mobile-app",
    route: "/apps/mobile-app",
    frontMatter: {
      "sidebarTitle": "Mobile App"
    }
  }, {
    name: "web-app",
    route: "/apps/web-app",
    frontMatter: {
      "sidebarTitle": "Web App"
    }
  }]
}, {
  name: "buy",
  route: "/buy",
  children: [{
    data: buy_meta
  }, {
    name: "index",
    route: "/buy",
    frontMatter: {
      "sidebarTitle": "Index"
    }
  }]
}, {
  name: "contact",
  route: "/contact",
  children: [{
    name: "contact",
    route: "/contact/contact",
    frontMatter: {
      "sidebarTitle": "Contact"
    }
  }]
}, {
  name: "docs",
  route: "/docs",
  children: [{
    data: docs_meta
  }, {
    name: "admin-panel",
    route: "/docs/admin-panel",
    children: [{
      data: docs_admin_panel_meta
    }, {
      name: "index",
      route: "/docs/admin-panel",
      frontMatter: {
        "sidebarTitle": "Index"
      }
    }, {
      name: "screenshots",
      route: "/docs/admin-panel/screenshots",
      frontMatter: {
        "sidebarTitle": "Screenshots"
      }
    }, {
      name: "settings",
      route: "/docs/admin-panel/settings",
      frontMatter: {
        "sidebarTitle": "Settings"
      }
    }]
  }, {
    name: "index",
    route: "/docs",
    frontMatter: {
      "sidebarTitle": "Index"
    }
  }, {
    name: "mobile-app",
    route: "/docs/mobile-app",
    children: [{
      data: docs_mobile_app_meta
    }, {
      name: "admob",
      route: "/docs/mobile-app/admob",
      frontMatter: {
        "sidebarTitle": "Admob"
      }
    }, {
      name: "architecture",
      route: "/docs/mobile-app/architecture",
      frontMatter: {
        "sidebarTitle": "Architecture"
      }
    }, {
      name: "deploy",
      route: "/docs/mobile-app/deploy",
      children: [{
        data: docs_mobile_app_deploy_meta
      }, {
        name: "android",
        route: "/docs/mobile-app/deploy/android",
        frontMatter: {
          "sidebarTitle": "Android"
        }
      }, {
        name: "env",
        route: "/docs/mobile-app/deploy/env",
        frontMatter: {
          "sidebarTitle": "Env"
        }
      }, {
        name: "ios",
        route: "/docs/mobile-app/deploy/ios",
        frontMatter: {
          "sidebarTitle": "iOS"
        }
      }, {
        name: "secure-maps",
        route: "/docs/mobile-app/deploy/secure-maps",
        frontMatter: {
          "sidebarTitle": "Secure Maps"
        }
      }]
    }, {
      name: "environment",
      route: "/docs/mobile-app/environment",
      frontMatter: {
        "sidebarTitle": "Environment"
      }
    }, {
      name: "firebase-integration",
      route: "/docs/mobile-app/firebase-integration",
      frontMatter: {
        "sidebarTitle": "Firebase Integration"
      }
    }, {
      name: "google-maps-integration",
      route: "/docs/mobile-app/google-maps-integration",
      frontMatter: {
        "sidebarTitle": "Google Maps Integration"
      }
    }, {
      name: "name-version-splash",
      route: "/docs/mobile-app/name-version-splash",
      frontMatter: {
        "sidebarTitle": "Name Version Splash"
      }
    }, {
      name: "revenue-cat",
      route: "/docs/mobile-app/revenue-cat",
      children: [{
        data: docs_mobile_app_revenue_cat_meta
      }, {
        name: "client",
        route: "/docs/mobile-app/revenue-cat/client",
        frontMatter: {
          "sidebarTitle": "Client"
        }
      }, {
        name: "index",
        route: "/docs/mobile-app/revenue-cat",
        frontMatter: {
          "sidebarTitle": "Index"
        }
      }, {
        name: "server",
        route: "/docs/mobile-app/revenue-cat/server",
        frontMatter: {
          "sidebarTitle": "Server"
        }
      }]
    }, {
      name: "running-in-dev",
      route: "/docs/mobile-app/running-in-dev",
      frontMatter: {
        "sidebarTitle": "Running in Dev"
      }
    }, {
      name: "setup-prerequisites",
      route: "/docs/mobile-app/setup-prerequisites",
      frontMatter: {
        "sidebarTitle": "Setup Prerequisites"
      }
    }]
  }, {
    name: "server",
    route: "/docs/server",
    children: [{
      data: docs_server_meta
    }, {
      name: "architecture",
      route: "/docs/server/architecture",
      frontMatter: {
        "sidebarTitle": "Architecture"
      }
    }, {
      name: "deploy",
      route: "/docs/server/deploy",
      frontMatter: {
        "sidebarTitle": "Deploy"
      }
    }, {
      name: "environment",
      route: "/docs/server/environment",
      frontMatter: {
        "sidebarTitle": "Environment"
      }
    }, {
      name: "firebase-integration",
      route: "/docs/server/firebase-integration",
      frontMatter: {
        "sidebarTitle": "Firebase Integration"
      }
    }, {
      name: "google-bucket",
      route: "/docs/server/google-bucket",
      frontMatter: {
        "sidebarTitle": "Google Bucket"
      }
    }, {
      name: "google-maps",
      route: "/docs/server/google-maps",
      frontMatter: {
        "sidebarTitle": "Google Maps"
      }
    }, {
      name: "running-in-dev",
      route: "/docs/server/running-in-dev",
      frontMatter: {
        "sidebarTitle": "Running in Dev"
      }
    }, {
      name: "setup-prerequisites",
      route: "/docs/server/setup-prerequisites",
      frontMatter: {
        "sidebarTitle": "Setup Prerequisites"
      }
    }, {
      name: "tutorials",
      route: "/docs/server/tutorials",
      children: [{
        data: docs_server_tutorials_meta
      }, {
        name: "new-module",
        route: "/docs/server/tutorials/new-module",
        frontMatter: {
          "sidebarTitle": "New Module"
        }
      }]
    }]
  }, {
    name: "web",
    route: "/docs/web",
    children: [{
      data: docs_web_meta
    }, {
      name: "architecture",
      route: "/docs/web/architecture",
      frontMatter: {
        "sidebarTitle": "Architecture"
      }
    }, {
      name: "deploy",
      route: "/docs/web/deploy",
      frontMatter: {
        "sidebarTitle": "Deploy"
      }
    }, {
      name: "environment",
      route: "/docs/web/environment",
      frontMatter: {
        "sidebarTitle": "Environment"
      }
    }, {
      name: "firebase-integration",
      route: "/docs/web/firebase-integration",
      frontMatter: {
        "sidebarTitle": "Firebase Integration"
      }
    }, {
      name: "publish",
      route: "/docs/web/publish",
      frontMatter: {
        "sidebarTitle": "Publish"
      }
    }, {
      name: "push-notifications",
      route: "/docs/web/push-notifications",
      frontMatter: {
        "sidebarTitle": "Push Notifications"
      }
    }, {
      name: "running-in-dev",
      route: "/docs/web/running-in-dev",
      frontMatter: {
        "sidebarTitle": "Running in Dev"
      }
    }, {
      name: "setup-prerequisites",
      route: "/docs/web/setup-prerequisites",
      frontMatter: {
        "sidebarTitle": "Setup Prerequisites"
      }
    }, {
      name: "stripe",
      route: "/docs/web/stripe",
      frontMatter: {
        "sidebarTitle": "Stripe"
      }
    }]
  }]
}, {
  name: "index",
  route: "/",
  frontMatter: {
    "sidebarTitle": "Index"
  }
}, {
  name: "terms",
  route: "/terms",
  children: [{
    data: terms_meta
  }, {
    name: "cookies",
    route: "/terms/cookies",
    frontMatter: {
      "sidebarTitle": "Cookies"
    }
  }, {
    name: "index",
    route: "/terms",
    frontMatter: {
      "sidebarTitle": "Index"
    }
  }, {
    name: "privacy",
    route: "/terms/privacy",
    frontMatter: {
      "sidebarTitle": "Privacy"
    }
  }]
}];