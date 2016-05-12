module.exports = function(grunt) {
  grunt.initConfig({
    watch: {
      scripts: {
        files: ['src/coffee/**/*.coffee'],
        tasks: ['coffee']
      }
    },
    clean: {
      build: ['build/']
    },
    coffee: {
      main: {
        options: {
          join: true
        },
        files: {
          'build/js/app.js': ['src/coffee/*.coffee']
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('default', ['clean', 'coffee']);
};
