// Dependencies
var system = require('system'),
    webpage = require('webpage');

// Arguments check
var url = system.args[1];

if (url) {
  // Load page
  var page = webpage.create();

  // Set viewport
  page.viewportSize = {
    width: 1024,
    height: 800
  };

  page.open(url, function(status) {
    var attempts = 0;

    function checkPageReady() {
      var html;

      // Evaulate page
      html = page.evaluate(function() {
        var body = document.getElementsByTagName('body')[0];

        // Return HTML when page is fully loaded
        if (body.getAttribute('data-ready') === 'true') {
          return document.getElementsByTagName('html')[0].outerHTML;
        }
      });

      // Output HTML if defined and exit
      if (html) {
        console.log(html);
        phantom.exit();
      }

      // Break if too many attempts were made
      else if (attempts < 100) {
        attempts++;

        // Try again
        setTimeout(checkPageReady, 100);
      } else {
        console.error('Failed to wait for the requested page to load');
        phantom.exit();
      }
    }

    if (status === 'success') {
      // Check if page is fully loaded
      checkPageReady();
    } else {
      // Otherwise, if page cannot be found, exit
      phantom.exit();
    }
  });
}
