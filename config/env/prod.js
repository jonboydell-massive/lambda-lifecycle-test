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
    cz: 'eu',
    gb: 'eu',
    jp: 'jp',
  },
  redirects: {
    it: 'http://watch.dazn.com/it-IT/sports/',
  },
  origins: {
    us: 'prod-webfacing-1417259680.us-west-2.elb.amazonaws.com',
    eu: 'isl-1727429181.eu-central-1.elb.amazonaws.com',
    ca: 'isl-73330730.us-east-1.elb.amazonaws.com',
    jp: 'isl-1079504087.ap-northeast-1.elb.amazonaws.com',
  },
  router: [
    {
      regex: '^[/]$',
      type: 'origin',
      regions: ['us', 'eu'],
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
