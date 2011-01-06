# node-settings

Simple, hierarchical environment-based app settings.

## Installation

    npm install node-settings

## Usage 

Configuration file `config/environment.js`

    exports.common = {
      storage: {
        host: 'localhost',
        database: 'server_dev',
        user: 'qirogami_user',
        password: 'password'
      }
    };

    // Rest of environments are deep merged over `common`.

    exports.development = {};

    exports.test = {
      storage: {
        database: 'server_test',
        password: 'foo'
      }
    };

    exports.production = {
        storage: {
            password: 'secret'
        }
    };

Application file

    var Settings = require('settings');
    var file = __dirname + '/config/environment.js';
    var settings = new Settings(file).getEnvironment('test');
   
    // inherited from common
    assert.equal(settings.storage.host, 'localhost');

    // specific to test
    assert.equal(settings.storage.password, 'foo');


### Environments

The environment to use is based on (highest precedence first):

1. `forceEnv` property in settings file
   
    ## config/environment.js

    exports.forceEnv = 'production'

2. `$NODE_ENV` environment variable

    NODE_ENV=production node app.js

3. Environment argument passed to `Settings#getEnvironment()`

    # the environment argument is ignored if either of the above is set
    settings.getEnvironment('production')

### Install Globally

If `globalKey` option is present, the environment settings are installed
into global space.

    var settings = new Settings(file, { globalKey: '$settings' }).
                       getEnvironment();
   
    assert.equal($settings.storage.host, 'localhost');


### Application Defaults

Settings may be preset in code. These settings may be overridden
by the external configuration file.

    var settings = new Settings(file, { 
     globalKey: '$settings',
     defaults: {
       framework: {
         views: 'app/views'
       }
     }
    }).getEnvironment(); 


    assert.equal($settings.framework.views, 'app/views');


## Testing

    npm install expresso
    make test

## Notes

js files are generated by Coffee.


## Credits

[shimondoodkin's merge and clone functions](https://github.com/shimondoodkin/nodejs-clone-extend.git)
is one few libraries that performs a object deep merge (extend) suitable for configuration files.


## License

Copyright (C) 2010 by Mario L. Gutierrez <mario@mgutz.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
