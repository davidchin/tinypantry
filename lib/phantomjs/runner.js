var system = require('system'),
    url = system.args[1] || '';

if (url.length > 0) {
  var webpage = require('webpage'),
      page = webpage.create();

  page.open(url, function(status) {
    function checkPageReady() {
      var attempts = 0,
          html;

      html = page.evaluate(function() {
        var body = document.getElementsByTagName('body')[0];

        // Return HTML when page is fully loaded
        if (body.getAttribute('data-ready') === 'true') {
          return document.getElementsByTagName('html')[0].outerHTML;
        }
      });

      if (html) {
        console.log(html);
        phantom.exit();
      }

      // Break if made too many attemps
      else if (attempts < 100) {
        attempts++;

        // Try again
        setTimeout(checkPageReady, 100);
      }
    }

    if (status == 'success') {
      checkPageReady();
    }
  });
}
