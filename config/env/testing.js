module.exports = {
  headers: {
    country: 'CloudFront-Viewer-Country',
  },
  countries: {
    ca: 'ca',
    us: 'us',
    de: 'eu',
    it: 'eu',
    at: 'eu',
    ch: 'eu',
    jp: 'jp',
  },
  redirects: {
    gb: 'https://watch.dazn.com/it-IT',
    it: 'https://watch.dazn.com/it_IT',
  },
  origins: {
    us: 'test-webfacing-60549116.us-west-2.elb.amazonaws.com',
    eu: 'test-isl-956544802.eu-central-1.elb.amazonaws.com',
    ca: 'test-isl-1710094137.us-east-1.elb.amazonaws.com',
    jp: 'test-isl-1568944301.ap-northeast-1.elb.amazonaws.com',
  },
  router: [
    {
      regex: '^[/]$',
      type: 'origin',
      regions: ['us','eu'],
    },
    {
      regex: '\\/(?<isl>m?isl)\\/(?<version>v\\d*)\\/(?<service>.*)',
      mapping: {
        uri: '/%_isl_%/%_region_%/%_version_%/%_service_%',
        host: 'isl-%_region_%.dazn.com',
      },
      type: 'origin',
      regions: ['us'],
    },
    {
      regex: '\\/index.html$',
      type: 'origin',
      regions: ['us'],
    },
    {
      regex: '^\\/[a-z][a-z]-[A-Z][A-Z](\\/.*)?$',
      type: 'origin',
      regions: ['us'],
    },
  ],
};
