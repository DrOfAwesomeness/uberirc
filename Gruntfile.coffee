module.exports = (grunt) ->
  grunt.initConfig 
    pkg: grunt.file.readJSON('package.json')
    mochaTest: 
      test:
        options:
          reporter: 'spec'
          require: 'coffee-script/register'
        src: ['test/*.coffee']
    coffeelint:
      options:
        configFile: 'coffeelint.json'
      lint: ['lib/*.coffee']
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.registerTask 'default', ['mochaTest:test', 'coffeelint:lint']