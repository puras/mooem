'use strict'

module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        clean: {
            files: ['public/*', '.tmp']
        },
        watch: {
            emberTemplates: {
                // files: 'app/templates/{,*/}*.hbs',
                files: 'app/templates/{,**/}*.hbs',
                tasks: ['emberTemplates']
            },
            coffee: {
                // files: ['app/scripts/{,*/}*.coffee'],
                files: ['app/{,**/}*.coffee'],
                tasks: ['coffee:dist']
            },
            neuter: {
                // files: ['app/scripts/**/*.js'],
                // files: ['app/scripts/{,*/}*.coffee'],
                // files: ['app/.tmp/scripts/{,*/}*.js'],
                files: ['.tmp/app/{,**/}*.js'],
                tasks: ['neuter']
            },
            copy: {
                files: ['app/index.html'],
                tasks: ['copy:main']
            },
            copy_res: {
                files: ['app/assets/css/{,**/}*.css', 'app/assets/css/{,**/}*.js'],
                tasks: ['copy:res']
            },
            livereload: {
                options : {
                    livereload : 9090
                },
                files: [
                    'public/js/{,**/}*.js',
                    'public/{,**/}*.html',
                    'public/css/{,**/}*.css',
                    'public/img/{,**/}*.{png,jpg,jpeg,gif,webp,svg}'
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
                    'public/js/moofo-templates.js': 'app/templates/{,*/}*.hbs'
                }
            }
        },
        coffee: {
            dist: {
                files: [{
                    expand: true,
                    cwd: 'app',
                    // src: '{,*/}*.coffee',
                    src: '**/*.coffee',
                    dest: '.tmp/app',
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
                        return '.tmp/' + filepath;
                    }
                },
                src: '.tmp/app/app.js',
                dest: 'public/js/moofo-app.js'
            }
        },
        copy: {
            main: {
                files: [
                    {expand: true, cwd: 'app', src: ['index.html'], dest: 'public/'}
                ]
            }, 
            res: {
                files: [
                    {expand: true, cwd: 'app/assets/css', src: ['{,**/}*'], dest: 'public/css/'},
                    {expand: true, cwd: 'bower_components/bootstrap/dist/js', src: ['*.min.js'], dest: 'public/js/bootstrap/'},
                    {expand: true, cwd: 'bower_components/bootstrap/dist/css', src: ['*.css'], dest: 'public/css/'},
                    {expand: true, cwd: 'bower_components/bootstrap/dist/fonts', src: ['*'], dest: 'public/fonts/'},
                    {expand: true, cwd: 'bower_components/ember', src: ['*.min.js'], dest: 'public/js/ember/'},
                    {expand: true, cwd: 'bower_components/ember-data', src: ['*.min.js'], dest: 'public/js/ember/'},
                    {expand: true, cwd: 'bower_components/handlebars', src: ['*.min.js'], dest: 'public/js/ember/'},
                    {expand: true, cwd: 'bower_components/ember-i18n/lib', src: 'i18n.js', dest: 'public/js/ember/', rename: function(dest, src) { return dest + 'ember-' + src}},
                    {expand: true, cwd: 'bower_components/jquery/dist', src: ['*.min.*'], dest: 'public/js/jquery/'},
                ]
            }
        }
    });
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-neuter');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-ember-templates');
    grunt.loadNpmTasks('grunt-contrib-copy');

    grunt.registerTask('default', ['clean', 'copy', 'emberTemplates', 'coffee', 'neuter', 'watch']);
}