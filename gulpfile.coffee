gulp = require 'gulp'
plumber = require 'gulp-plumber'
stylus = require 'gulp-stylus'
nib = require 'nib'
notify = require 'gulp-notify'
header = require 'gulp-header'
minifyCSS = require 'gulp-minify-css'
rename = require 'gulp-rename'
bump = require 'gulp-bump'
browserSync = require 'browser-sync'
pkg = require './package.json'

banner = """
/*!
 * @license #{pkg.name} v#{pkg.version}
 * (c) #{new Date().getFullYear()} #{pkg.author} #{pkg.homepage}
 * License: #{pkg.license}
 */

"""

fileName = 'endroll'

gulp.task 'stylus', ->
  gulp.src "src/#{fileName}.styl"
    .pipe plumber
      errorHandler: notify.onError '<%= error.message %>'

    .pipe stylus
      use: nib()
      compress: false
    .pipe header(banner)
    .pipe gulp.dest('dest/')

gulp.task 'serve', ->
  browserSync
    server:
      baseDir: './'
      index: 'public/index.html'

gulp.task 'default', ['serve'], ->
  gulp.watch ["src/#{fileName}.styl"], ['stylus', browserSync.reload]

gulp.task 'major', ->
  gulp.src './*.json'
    .pipe bump(
      type: 'major'
    )
    .pipe gulp.dest('./')

gulp.task 'minor', ->
  gulp.src './*.json'
    .pipe bump(
      type: 'minor'
    )
    .pipe gulp.dest('./')

gulp.task 'patch', ->
  gulp.src './*.json'
    .pipe bump(
      type: 'patch'
    )
    .pipe gulp.dest('./')

gulp.task 'build', ['stylus'], ->
  gulp.src "dest/#{fileName}.css"
    .pipe minifyCSS()
    .pipe rename
      extname: '.min.css'
    .pipe gulp.dest('dest/')
