// Taken from https://github.com/aws-samples/amazon-cloudfront-functions/blob/4b5606630db439f3d47c9964547f532646dd2c65/url-rewrite-single-page-apps/index.js

function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Check whether the URI is missing a file name.
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    }
    // Check whether the URI is missing a file extension.
    else if (!uri.includes('.')) {
        request.uri += '/index.html';
    }

    return request;
}
