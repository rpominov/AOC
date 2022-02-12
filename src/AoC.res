let getInput: (string, string, string => unit) => unit = %raw(`
  function(year, day, cb) {
    const fs = require('fs');
    const https = require('https');

    function done(data) {
      console.log(data);
      console.log("=======================================================================");
      const start = new Date();
      cb(data);
      console.log('Took:', new Date() - start, 'ms');
    }

    const cacheFileName = __dirname + '/../inputs/' + year + "_" + day + '.txt'

    if (fs.existsSync(cacheFileName)) {
      done(fs.readFileSync(cacheFileName, 'utf8'));
      return;
    }


    https.get("https://adventofcode.com/" + year + "/day/" + day + "/input", 
      {headers: {cookie: "session=__SESSION__"}}, 
      function(res) {
        if (res.statusCode !== 200) {
          console.error("Can't load input. Status code:", res.statusCode);
          return;
        }
      
        res.setEncoding('utf8');
        let rawData = '';
        res.on('data', (chunk) => { rawData += chunk; });
        res.on('end', () => { 
          fs.writeFileSync(cacheFileName, rawData)
          done(rawData) 
        });
      }
    ).on('error', function(e) {
      console.error("Can't load input:", e.message);
    })
  }
`)
