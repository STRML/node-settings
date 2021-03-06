#
# Copyright(c) 2010 Mario L Gutierrez <mario@mgutz.com>
# MIT Licensed
#
# TODO - add watcher on settings file

assert = require('assert')
merger = require('../support/merger')

# IF coffee is installed, also read configs written in CoffeeScript.
try
  # coffee extension is registered with node as a side-effect
  require('coffee-script') # allows use of coffee for configs
catch ex


# Provides settings from an environment file or an object.
#
# The settings module must export, at a minimum, a `common` property.
# Other environments are deep merged over `common`.
#
# @param {String | Object} pathOrModule The file to load or an object.
#
# @example
#
# exports.common = {connectionString: 'mysql_dev'};
#
# exports.development = {};
# exports.test = {connectionString: 'mysql_test'};
#
# development.connectionString === 'mysql_dev';
# test.connectionString === 'mysql_test';
#
Settings = (pathOrModule, @options = {}) ->

  if typeof pathOrModule == 'string'
    @path = pathOrModule

  @environments = Settings.loadModule(pathOrModule)

  if @options.globalKey?
    @_settings = @getEnvironment()
    global.__defineGetter__ @options.globalKey, =>
      @_settings

  this


# Get settings for a specific environment.
#
# @param {String} environ [optional] The environment to retrieve.
#
# If `environ` is not passed, an environment is selected in this order
#
#  1. Module's `forceEnv` property
#  2. $NODE_ENV environment variable
#  3. `common` environment
#
Settings.prototype.getEnvironment = (environ) ->
  @env = @environments.forceEnv || environ || process.env.NODE_ENV || 'common'

  assert.ok @environments.common, 'Environment common not found in: ' + @path
  assert.ok @environments[@env], 'Environment `' + @env + '` not found in: ' + @path

  if @options.defaults?
    common = merger.cloneextend(@options.defaults, @environments.common)
  else
    common = merger.clone(@environments.common)

  if @env == 'common'
    result = common
  else
    result = merger.extend common, @environments[@env]

  if @options.globalKey?
    @_settings = result

  result.override = Settings.override
  result

Settings.loadModule = (pathOrModule) ->
  if typeof pathOrModule == 'string'
    require(pathOrModule)
  else
    pathOrModule

Settings.override = (pathOrModule) ->
  mod = Settings.loadModule(pathOrModule)
  if mod.common?
    mod = new Settings(mod).getEnvironment()
  merger.extend this, mod
  this


module.exports = Settings
