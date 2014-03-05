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
                // files: 'app/templates/{,*/}*.hbs',
                files: 'app/templates/**/*.hbs',
                tasks: ['emberTemplates']
            },
            coffee: {
                // files: ['app/scripts/{,*/}*.coffee'],
                files: ['app/scripts/**/*.coffee'],
                tasks: ['coffee:dist']
            },
            neuter: {
                // files: ['app/scripts/**/*.js'],
                // files: ['app/scripts/{,*/}*.coffee'],
                // files: ['app/.tmp/scripts/{,*/}*.js'],
                files: ['app/.tmp/scripts/**/*.js'],
                tasks: ['neuter']
            },
            livereload: {
                options : {
                    livereload : 9090
                },
                files: [
                    'app/.tmp/dist/{,*/}*.js',
                    'app/*.html',
                    'app/assets/styles/{,*/}*.css',
                    'app/assets/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
                ]
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
                    'app/.tmp/dist/mooem-templates.js': 'app/templates/{,*/}*.hbs'
                }
            }
        },
        coffee: {
            dist: {
                files: [{
                    expand: true,
                    cwd: 'app/scripts',
                    // src: '{,*/}*.coffee',
                    src: '**/*.coffee',
                    dest: 'app/.tmp/scripts',
                    ext: '.js'
                }]
            },
            test: {
                files: [{
                    expand: true,
                    cwd: 'test/spec',
                    src: '{,*/}*.coffee',
                    dest: '.tmp/spec',
                    ext: '.js'
                }]
            }
        },
        neuter: {
            app: {
                options: {
                    template: "{%= src %}",
                    filepathTransform: function(filepath) {
                        return 'app/.tmp/' + filepath;
                    }
                },
                src: 'app/.tmp/scripts/app.js',
                dest: 'app/.tmp/dist/mooem-scripts.js'
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