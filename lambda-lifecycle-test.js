function getRequest(event) {
  if (event.Records && event.Records.length > 0 && event.Records[0].cf) {
    return event.Records[0].cf.request || null;
  }
  return null;
};

function getResponse(event) {
  if (event.Records && event.Records.length > 0 && event.Records[0].cf) {
    return event.Records[0].cf.response || null;
  }
  return null;
};

function getConfig(event) {
  if (event.Records && event.Records.length > 0 && event.Records[0].cf) {
    return event.Records[0].cf.config || null;
  }
  return null;
}

exports.handler = (event, context, callback) => {
  const request = getRequest(event);
  const response = getResponse(event);
  const config = getConfig(event);

  const log = {
    config,
    request,
    response: {}
  };

  if (response) {
    log.response = response;
  }

  console.log(JSON.stringify(log));

  if (response) {
    callback(null, response);
  } else {
    callback(null, request);
  }
};
