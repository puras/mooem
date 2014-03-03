'use strict'

module.exports = function (grunt) {

    // require('load-grunt-tasks')(grunt);

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        clean: {
            files: ['dist']
        },
        watch: {
            emberTemplates: {
                files: 'app/templates/{,*/}*.hbs',
                tasks: ['emberTemplates']
            },
            neuter: {
                files: ['app/scripts/**/*.js'],
                // files: ['app/scripts/{,*/}*.coffee'],
                tasks: ['neuter']
            },
            livereload: {
                options : {
                    livereload : 9090
                },
                files: [
                    'app/.tmp/scripts/{,*/}*.js',
                    'app/*.html',
                    'app/assets/styles/{,*/}*.css',
                    'app/assets/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
                ]
            }
        },
        neuter: {
            app: {
                options: {
                    filepathTransform: function(filepath) {
                        return 'app/' + filepath;
                    }
                },
                src: 'app/scripts/app.js',
                dest: 'app/.tmp/scripts/mooem-scripts.js'
            }
        },
        coffee: {
            compile: {
                files: {
                    'app/.tmp/scripts/app.js': 'app/.tmp/coffee/mooem-scripts.coffee'
                }
            }
        },
        emberTemplates: {
            options: {
                templateName: function(sourceFile) {
                    var templatePath = 'app/templates/';
                    return sourceFile.replace(templatePath, '');
                }
            },
            dist: {
                files: {
                    'app/.tmp/scripts/compiled-templates.js': 'app/templates/{,*/}*.hbs'
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-neuter');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-ember-templates');

    grunt.registerTask('default', ['clean']);
}