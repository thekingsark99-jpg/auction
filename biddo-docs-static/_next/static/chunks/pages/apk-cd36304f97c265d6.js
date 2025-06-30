; (self.webpackChunk_N_E = self.webpackChunk_N_E || []).push([
  [3876],
  {
    8991: function (e, t, r) {
      ; (window.__NEXT_P = window.__NEXT_P || []).push([
        '/apk',
        function () {
          return r(1268)
        },
      ])
    },
    1268: function (e, t, r) {
      'use strict'
      r.r(t),
        r.d(t, {
          useTOC: function () {
            return s
          },
        })
      var i = r(5893),
        n = r(7812),
        a = r(2838),
        o = r(8925)
      function s(e) {
        return [
          { value: 'Download APK file', id: 'download-apk-file', depth: 2 },
        ]
      }
      t.default = (0, n.c)(
        function (e) {
          let { toc: t = s(e) } = e,
            r = { a: 'a', h2: 'h2', p: 'p', ...(0, o.a)(), ...e.components }
          return (0, i.jsxs)(i.Fragment, {
            children: [
              (0, i.jsx)(r.h2, { id: t[0].id, children: t[0].value }),
              '\n',
              (0, i.jsxs)(r.p, {
                children: [
                  'You can download the APK file from the following link:\n',
                  (0, i.jsx)(r.a, {
                    href: 'https://cdn.tanna.app/biddo/app-release-v0.15.apk',
                    children:
                      'https://cdn.tanna.app/biddo/app-release-v0.15.apk',
                  }),
                ],
              }),
            ],
          })
        },
        '/apk',
        {
          filePath: 'pages/apk/index.mdx',
          timestamp: 1733617437e3,
          pageMap: a.v,
          frontMatter: {},
          title: 'Index',
        },
        'undefined' == typeof RemoteContent ? s : RemoteContent.useTOC
      )
    },
    8925: function (e, t, r) {
      'use strict'
      r.d(t, {
        a: function () {
          return l
        },
      })
      var i = r(1151),
        n = r(5675),
        a = r.n(n),
        o = r(7294)
      let s = {
        img: (e) =>
          (0, o.createElement)('object' == typeof e.src ? a() : 'img', e),
      },
        l = (e) => (0, i.a)({ ...s, ...e })
    },
    7812: function (e, t, r) {
      'use strict'
      r.d(t, {
        c: function () {
          return d
        },
      })
      var i = r(5893),
        n = r(3665),
        a = r(8644)
      let o = (0, r(7294).createContext)({}),
        s = o.Provider
      o.displayName = 'SSG'
      var l = r(8925)
      function d(e, t, r, i) {
        let a = globalThis[n.ud]
        return (
          (a.route = t),
          (a.pageMap = r.pageMap),
          (a.context[t] = { Content: e, pageOpts: r, useTOC: i }),
          p
        )
      }
      function p({ __nextra_pageMap: e = [], __nextra_dynamic_opts: t, ...r }) {
        let o = globalThis[n.ud],
          { Layout: l, themeConfig: d } = o,
          { route: p, locale: c } = (0, a.t)(),
          m = o.context[p]
        if (!m)
          throw Error(
            `No content found for the "${p}" route. Please report it as a bug.`
          )
        let { pageOpts: b, useTOC: f, Content: g } = m
        if (p.startsWith('/[')) b.pageMap = e
        else
          for (let { route: t, children: r } of e) {
            let e = t.split('/').slice(c ? 2 : 1)
              ; (function e(t, [r, ...i]) {
                for (let n of t)
                  if ('children' in n && r === n.name)
                    return i.length ? e(n.children, i) : n
              })(b.pageMap, e).children = r
          }
        if (t) {
          let { title: e, frontMatter: r } = t
          b = { ...b, title: e, frontMatter: r }
        }
        return (0, i.jsx)(l, {
          themeConfig: d,
          pageOpts: b,
          pageProps: r,
          children: (0, i.jsx)(s, {
            value: r,
            children: (0, i.jsx)(u, {
              useTOC: f,
              children: (0, i.jsx)(g, { ...r }),
            }),
          }),
        })
      }
      function u({ children: e, useTOC: t }) {
        let { wrapper: r } = (0, l.a)()
        return (0, i.jsx)(c, { useTOC: t, wrapper: r, children: e })
      }
      function c({ children: e, useTOC: t, wrapper: r, ...n }) {
        let a = t(n)
        return r ? (0, i.jsx)(r, { toc: a, children: e }) : e
      }
    },
    2838: function (e, t, r) {
      'use strict'
      r.d(t, {
        v: function () {
          return i
        },
      })
      let i = [
        {
          data: {
            apps: { title: 'Apps', type: 'page' },
            terms: { title: 'Terms of Service', type: 'page' },
            apk: { title: 'APK Download', type: 'page' },
            docs: { type: 'page', title: 'Quick Start' },
            contact: { type: 'page', title: 'Contact' },
            index: { title: 'Documentation', display: 'hidden' },
            buy: { title: 'Buy Now', type: 'page' },
          },
        },
        {
          name: 'apk',
          route: '/apk',
          children: [
            {
              name: 'index',
              route: '/apk',
              frontMatter: { sidebarTitle: 'Index' },
            },
          ],
        },
        {
          name: 'apps',
          route: '/apps',
          children: [
            {
              data: {
                'mobile-app': { title: 'Mobile App' },
                'web-app': { title: 'Web App' },
              },
            },
            {
              name: 'mobile-app',
              route: '/apps/mobile-app',
              frontMatter: { sidebarTitle: 'Mobile App' },
            },
            {
              name: 'web-app',
              route: '/apps/web-app',
              frontMatter: { sidebarTitle: 'Web App' },
            },
          ],
        },
        {
          name: 'buy',
          route: '/buy',
          children: [
            { data: { index: { title: 'Buy Biddo' } } },
            {
              name: 'index',
              route: '/buy',
              frontMatter: { sidebarTitle: 'Index' },
            },
          ],
        },
        {
          name: 'contact',
          route: '/contact',
          children: [
            {
              name: 'contact',
              route: '/contact/contact',
              frontMatter: { sidebarTitle: 'Contact' },
            },
          ],
        },
        {
          name: 'docs',
          route: '/docs',
          children: [
            {
              data: {
                index: { title: 'Introduction' },
                server: 'NodeJS Server',
                'admin-panel': 'Admin Panel',
                'mobile-app': 'Mobile App',
                web: 'Web App',
              },
            },
            {
              name: 'admin-panel',
              route: '/docs/admin-panel',
              children: [
                {
                  data: {
                    index: { title: 'Setup' },
                    settings: { title: 'Settings' },
                  },
                },
                {
                  name: 'index',
                  route: '/docs/admin-panel',
                  frontMatter: { sidebarTitle: 'Index' },
                },
                {
                  name: 'screenshots',
                  route: '/docs/admin-panel/screenshots',
                  frontMatter: { sidebarTitle: 'Screenshots' },
                },
                {
                  name: 'settings',
                  route: '/docs/admin-panel/settings',
                  frontMatter: { sidebarTitle: 'Settings' },
                },
              ],
            },
            {
              name: 'index',
              route: '/docs',
              frontMatter: { sidebarTitle: 'Index' },
            },
            {
              name: 'mobile-app',
              route: '/docs/mobile-app',
              children: [
                {
                  data: {
                    'setup-prerequisites': { title: 'Setup Prerequisites' },
                    environment: { title: 'Environment Variables' },
                    'name-version-splash': {
                      title: 'Name, Version, Splash Screen',
                    },
                    'firebase-integration': { title: 'Firebase Integration' },
                    'google-maps-integration': {
                      title: 'Google Maps Integration',
                    },
                    architecture: { title: 'Code Architecture' },
                    'running-in-dev': { title: 'Running in Development' },
                    deploy: { title: 'Deploy' },
                    admob: { title: 'Admob Integration' },
                    'revenue-cat': 'In App Purchases',
                  },
                },
                {
                  name: 'admob',
                  route: '/docs/mobile-app/admob',
                  frontMatter: { sidebarTitle: 'Admob' },
                },
                {
                  name: 'architecture',
                  route: '/docs/mobile-app/architecture',
                  frontMatter: { sidebarTitle: 'Architecture' },
                },
                {
                  name: 'deploy',
                  route: '/docs/mobile-app/deploy',
                  children: [
                    {
                      data: {
                        env: { title: 'Environment Variables' },
                        android: { title: 'Android' },
                        ios: { title: 'iOS' },
                        'secure-maps': { title: 'Secure Google Maps Key' },
                      },
                    },
                    {
                      name: 'android',
                      route: '/docs/mobile-app/deploy/android',
                      frontMatter: { sidebarTitle: 'Android' },
                    },
                    {
                      name: 'env',
                      route: '/docs/mobile-app/deploy/env',
                      frontMatter: { sidebarTitle: 'Env' },
                    },
                    {
                      name: 'ios',
                      route: '/docs/mobile-app/deploy/ios',
                      frontMatter: { sidebarTitle: 'iOS' },
                    },
                    {
                      name: 'secure-maps',
                      route: '/docs/mobile-app/deploy/secure-maps',
                      frontMatter: { sidebarTitle: 'Secure Maps' },
                    },
                  ],
                },
                {
                  name: 'environment',
                  route: '/docs/mobile-app/environment',
                  frontMatter: { sidebarTitle: 'Environment' },
                },
                {
                  name: 'firebase-integration',
                  route: '/docs/mobile-app/firebase-integration',
                  frontMatter: { sidebarTitle: 'Firebase Integration' },
                },
                {
                  name: 'google-maps-integration',
                  route: '/docs/mobile-app/google-maps-integration',
                  frontMatter: { sidebarTitle: 'Google Maps Integration' },
                },
                {
                  name: 'name-version-splash',
                  route: '/docs/mobile-app/name-version-splash',
                  frontMatter: { sidebarTitle: 'Name Version Splash' },
                },
                {
                  name: 'revenue-cat',
                  route: '/docs/mobile-app/revenue-cat',
                  children: [
                    {
                      data: {
                        index: { title: 'Setup RevenueCat' },
                        client: { title: 'Mobile App Configuration' },
                        server: { title: 'Server Configuration' },
                      },
                    },
                    {
                      name: 'client',
                      route: '/docs/mobile-app/revenue-cat/client',
                      frontMatter: { sidebarTitle: 'Client' },
                    },
                    {
                      name: 'index',
                      route: '/docs/mobile-app/revenue-cat',
                      frontMatter: { sidebarTitle: 'Index' },
                    },
                    {
                      name: 'server',
                      route: '/docs/mobile-app/revenue-cat/server',
                      frontMatter: { sidebarTitle: 'Server' },
                    },
                  ],
                },
                {
                  name: 'running-in-dev',
                  route: '/docs/mobile-app/running-in-dev',
                  frontMatter: { sidebarTitle: 'Running in Dev' },
                },
                {
                  name: 'setup-prerequisites',
                  route: '/docs/mobile-app/setup-prerequisites',
                  frontMatter: { sidebarTitle: 'Setup Prerequisites' },
                },
              ],
            },
            {
              name: 'server',
              route: '/docs/server',
              children: [
                {
                  data: {
                    'setup-prerequisites': { title: 'Setup Prerequisites' },
                    environment: { title: 'Environment Variables' },
                    'firebase-integration': { title: 'Firebase Integration' },
                    'google-bucket': {
                      title: 'Google Cloud Storage Integration',
                    },
                    'google-maps': { title: 'Google Maps Integration' },
                    architecture: { title: 'Code Architecture' },
                    'running-in-dev': { title: 'Running in Development' },
                    tutorials: { title: 'Tutorials' },
                    deploy: { title: 'Deploy' },
                  },
                },
                {
                  name: 'architecture',
                  route: '/docs/server/architecture',
                  frontMatter: { sidebarTitle: 'Architecture' },
                },
                {
                  name: 'deploy',
                  route: '/docs/server/deploy',
                  frontMatter: { sidebarTitle: 'Deploy' },
                },
                {
                  name: 'environment',
                  route: '/docs/server/environment',
                  frontMatter: { sidebarTitle: 'Environment' },
                },
                {
                  name: 'firebase-integration',
                  route: '/docs/server/firebase-integration',
                  frontMatter: { sidebarTitle: 'Firebase Integration' },
                },
                {
                  name: 'google-bucket',
                  route: '/docs/server/google-bucket',
                  frontMatter: { sidebarTitle: 'Google Bucket' },
                },
                {
                  name: 'google-maps',
                  route: '/docs/server/google-maps',
                  frontMatter: { sidebarTitle: 'Google Maps' },
                },
                {
                  name: 'running-in-dev',
                  route: '/docs/server/running-in-dev',
                  frontMatter: { sidebarTitle: 'Running in Dev' },
                },
                {
                  name: 'setup-prerequisites',
                  route: '/docs/server/setup-prerequisites',
                  frontMatter: { sidebarTitle: 'Setup Prerequisites' },
                },
                {
                  name: 'tutorials',
                  route: '/docs/server/tutorials',
                  children: [
                    { data: { 'new-module': { title: 'Add a new module' } } },
                    {
                      name: 'new-module',
                      route: '/docs/server/tutorials/new-module',
                      frontMatter: { sidebarTitle: 'New Module' },
                    },
                  ],
                },
              ],
            },
            {
              name: 'web',
              route: '/docs/web',
              children: [
                {
                  data: {
                    'setup-prerequisites': { title: 'Setup Prerequisites' },
                    environment: { title: 'Environment Variables' },
                    'firebase-integration': { title: 'Firebase Integration' },
                    'push-notifications': {
                      title: 'Enable Push Notifications',
                    },
                    stripe: { title: 'Stripe Integration' },
                    architecture: { title: 'Code Architecture' },
                    'running-in-dev': { title: 'Running in Development' },
                    publish: { title: 'Publishing' },
                    deploy: { title: 'Deploy' },
                  },
                },
                {
                  name: 'architecture',
                  route: '/docs/web/architecture',
                  frontMatter: { sidebarTitle: 'Architecture' },
                },
                {
                  name: 'deploy',
                  route: '/docs/web/deploy',
                  frontMatter: { sidebarTitle: 'Deploy' },
                },
                {
                  name: 'environment',
                  route: '/docs/web/environment',
                  frontMatter: { sidebarTitle: 'Environment' },
                },
                {
                  name: 'firebase-integration',
                  route: '/docs/web/firebase-integration',
                  frontMatter: { sidebarTitle: 'Firebase Integration' },
                },
                {
                  name: 'publish',
                  route: '/docs/web/publish',
                  frontMatter: { sidebarTitle: 'Publish' },
                },
                {
                  name: 'push-notifications',
                  route: '/docs/web/push-notifications',
                  frontMatter: { sidebarTitle: 'Push Notifications' },
                },
                {
                  name: 'running-in-dev',
                  route: '/docs/web/running-in-dev',
                  frontMatter: { sidebarTitle: 'Running in Dev' },
                },
                {
                  name: 'setup-prerequisites',
                  route: '/docs/web/setup-prerequisites',
                  frontMatter: { sidebarTitle: 'Setup Prerequisites' },
                },
                {
                  name: 'stripe',
                  route: '/docs/web/stripe',
                  frontMatter: { sidebarTitle: 'Stripe' },
                },
              ],
            },
          ],
        },
        { name: 'index', route: '/', frontMatter: { sidebarTitle: 'Index' } },
        {
          name: 'terms',
          route: '/terms',
          children: [
            {
              data: {
                index: { title: 'Terms of Service' },
                privacy: { title: 'Privacy Policy' },
                cookies: { title: 'Cookies Policy' },
              },
            },
            {
              name: 'cookies',
              route: '/terms/cookies',
              frontMatter: { sidebarTitle: 'Cookies' },
            },
            {
              name: 'index',
              route: '/terms',
              frontMatter: { sidebarTitle: 'Index' },
            },
            {
              name: 'privacy',
              route: '/terms/privacy',
              frontMatter: { sidebarTitle: 'Privacy' },
            },
          ],
        },
      ]
    },
  },
  function (e) {
    e.O(0, [2888, 9774, 179], function () {
      return e((e.s = 8991))
    }),
      (_N_E = e.O())
  },
])
