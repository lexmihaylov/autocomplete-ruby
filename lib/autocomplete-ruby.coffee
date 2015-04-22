RsenseProvider = require './autocomplete-ruby-provider.coffee'
exec = require('child_process').exec

rsenseDaemon = (action) ->
  rsense = atom.config.get('autocomplete-ruby.rsense')

  if rsense != 'none'
    console.log("\t#{action}ing rsense ... ")
    exec(rsense + ' ' + action)
    console.log("\trsense: READY")

module.exports =
  config:
    port:
      description: 'The port the rsense server is running on'
      type: 'integer'
      default: 47367
      minimum: 1024
      maximum: 65535
    rsense:
      description: 'Path to rsense executable'
      type: 'string'
      default: 'none'

  rsenseProvider: null

  activate: (state) ->
    console.log('activate autocomplete-ruby')
    rsenseDaemon('start')
    @rsenseProvider = new RsenseProvider()

  provideAutocompletion: ->
    {providers: [@rsenseProvider]}

  deactivate: ->
    rsense = atom.config.get('autocomplete-ruby.rsense')
    rsenseDaemon('stop')
    @rsenseProvider?.dispose()
    @rsenseProvider = null
