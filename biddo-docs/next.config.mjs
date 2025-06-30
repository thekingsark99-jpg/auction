import nextra from 'nextra'

const withNextra = nextra({
  theme: 'nextra-theme-docs',
  themeConfig: './theme.config.jsx',
})

export default withNextra({
  // output: 'export',
  // assetPrefix: '.',
  // distDir: 'build',
  images: {
    unoptimized: true,
    domains: ['cdn.tanna.app'],
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'cdn.tanna.app',
        port: '',
        pathname: '/biddo/**',
      },
    ],
  },
})
