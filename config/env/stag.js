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
    us: 'stag-webfacing-1639174423.us-west-2.elb.amazonaws.com',
    eu: 'stag-isl-1657488039.eu-central-1.elb.amazonaws.com',
    ca: 'stag-isl-1030234855.us-east-1.elb.amazonaws.com',
    jp: 'stag-isl-1036914315.ap-northeast-1.elb.amazonaws.com',
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
