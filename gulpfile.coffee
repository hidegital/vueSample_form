gulp       = require 'gulp'
watch      = require 'gulp-watch'
fs         = require 'fs'

browserify = require 'browserify'
watchify   = require 'watchify' #browserifyのコンパイルを早くする
uglify     = require 'gulp-uglify' #js圧縮
source     = require 'vinyl-source-stream' #gulp で Browserify を扱う際に利用
buffer     = require 'vinyl-buffer'
transform  = require 'vinyl-transform'
vueify     = require 'vueify'

consolidate   = require 'gulp-consolidate' #gulpfileの変数をテンプレートエンジンで使用するためのモジュール

browserSync = require 'browser-sync'

data = require 'gulp-data'
plumber = require 'gulp-plumber' #エラー時に止めない

stylus = require 'gulp-stylus'
koutoSwiss = require 'kouto-swiss'
pleeease = require 'gulp-pleeease' #autoprefixer
csscomb = require 'gulp-csscomb'
cssmin = require 'gulp-cssmin'
sourcemaps = require 'gulp-sourcemaps'

babelify = require 'babelify'

ejs = require 'gulp-ejs'
jade = require 'gulp-jade'
htmlhint = require 'gulp-htmlhint'
prettify = require 'gulp-prettify'

del = require 'del'
runSequence = require 'run-sequence'
header  = require 'gulp-header'

coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
uglify  = require 'gulp-uglify'
jsonminify = require 'gulp-jsonminify'
imagemin = require 'gulp-imagemin'

#TODO sitemap
sitemap = require 'gulp-sitemap'

#imageResize
changed     = require 'gulp-changed'
filelog     = require 'gulp-filelog'
imageResize = require 'gulp-image-resize'

#path
distJs            = './dist/js'
buildJs           = './build/js'
stylusPath        = './src/stylus'
distCss           = './dist/css'
buildCss          = './build/css'
srcImg            = './src/img'
buildImg          = './build/img'
DEST              = './dist'
SRC               = './src'

#ejsjson
#ejsJson = require 'gulp-ejs-json'

#sprite
spritesmith = require 'gulp.spritesmith'

#_ = require 'underscore'

#cash用
rev = require 'gulp-rev'
revReplace = require 'gulp-rev-replace'
useref = require 'gulp-useref'
gulpif = require 'gulp-if'


gulp.task 'index', ->
    gulp.src([
        'dist/css/*.css'
        'dist/css/**/*css'
        'dist/js/*.js'
        'dist/js/**/*.js'
    ], base: 'dist')
    .pipe(gulp.dest('dist'))
    .pipe(rev())
    .pipe(gulp.dest('build/'))
    .pipe(rev.manifest())
    .pipe gulp.dest('dist')

gulp.task 'revreplace', ->
    manifest = gulp.src('./dist' + '/rev-manifest.json')
    gulp.src('./dist' + '/index.html')
        .pipe(revReplace(manifest: manifest))
        .pipe gulp.dest('./build')

#js
gulp.task 'js', ->
    browserify
        entries: [
            './src/js/app.js'
        ]
    .transform 'babelify'
    .transform 'vueify'
    .bundle()
    .pipe source 'app.js'
    .pipe gulp.dest distJs

gulp.task 'jsReload', (callback) ->
    runSequence 'js', 'bsReload', callback

#server
gulp.task 'browserSync', ->
    browserSync
        notify: false,
        port: 3000,
        server: {
            baseDir: ['./dist/']
        }
gulp.task 'bsReload', ->
    browserSync.reload()

#css
gulp.task 'stylus', ->
    gulp.src [stylusPath + '/*.styl','!' + stylusPath + '/_*/*.styl']
    .pipe plumber()
    .pipe sourcemaps.init()
    .pipe stylus(
        use:koutoSwiss()
    )
    .pipe sourcemaps.write()
    .pipe pleeease(
        minifier: false,
        autoprefixer: {"browsers": ["last 4 versions"]}
    )
    .pipe csscomb()
    .on('error', console.error.bind(console))
    .pipe (header('@charset "utf-8";\n'))
    .pipe (gulp.dest(distCss))

gulp.task 'cleanCss', ->
    del('./dist/css/*.css')

gulp.task 'stylusReload', (callback) ->
  runSequence 'cleanCss','stylus', 'bsReload', callback

#templeteに変数を渡す jadeのjsonと同時に使えない
#consolidateOptions =
#    pathName: 'test'
#        .pipe consolidate 'jade',
#            consolidateOptions

#htmltemplate
gulp.task 'jade', ->
    gulp.src ["src/jade/**/*.jade",'!' + "src/jade/**/_*.jade"]
        .pipe(data((file) ->
            require './src/data/list.json'
        ))
        .pipe plumber()
        .pipe jade(
            pretty: true
        )
        .pipe gulp.dest DEST

gulp.task 'jadeReload', (callback) ->
    runSequence 'jade', 'bsReload', callback

#gulp.task 'ejs', ->
#    gulp.src ["src/ejs/**/*.ejs",'!' + "src/ejs/**/_*.ejs"]
#    .pipe plumber()
#    .pipe ejs()
#    .pipe gulp.dest DEST

#gulp.task 'ejsReload', (callback) ->
#    runSequence 'ejs', 'bsReload', callback

gulp.task 'htmlhint', ->
    gulp.src('./dist/*.html')
        .pipe htmlhint()
        .pipe htmlhint.reporter()

#sprite
gulp.task 'spriteStylus', ->
    spriteData = gulp.src 'src/img/sprite/*.png'
    .pipe plumber()
    .pipe spritesmith
        imgName: 'sprite.png',
        cssName: 'sprite.styl',
        algorithm: 'binary-tree',
        padding: 5,
        cssFormat: 'stylus'
    spriteData.img
    .pipe gulp.dest('dist/img/')
    spriteData.css
    .pipe gulp.dest(stylusPath + '/_partial');

#minify系
gulp.task 'imagemin', ->
    dstGlob = buildImg;
    imageminOptions = optimizationLevel: 7
    gulp.src [srcImg + '/**/*.+(jpg|jpeg|png|gif|svg)','!' + srcImg + '/sprite/*.+(jpg|jpeg|png|gif|svg)']
        .pipe imagemin(imageminOptions)
        .pipe gulp.dest(dstGlob)
        .pipe gulp.dest('dist/img/')


#imageresize用 resizeOptionsでサイズは指定
paths =
    srcDir: 'src'
    prvDir: 'prv'
    dstDir: 'prd'
    uploadsDir: '/uploads'
gulp.task 'image-optim:thumb', ->
    baseDir = paths.srcDir + paths.uploadsDir + '/origin'
    srcGlob = paths.srcDir + paths.uploadsDir + '/origin/**/*.+(jpg|jpeg|png|gif)'
    dstGlob = paths.dstDir + paths.uploadsDir + '/thumb'
    resizeOptions =
        width: 200
        height: 200
        gravity: 'Center'
        crop: true
        upscale: false
        imageMagick: true
    imageminOptions = optimizationLevel: 7
    gulp.src(srcGlob, base: baseDir)
    .pipe(changed(dstGlob))
    .pipe(imageResize(resizeOptions))
    .pipe(imagemin(imageminOptions))
    .pipe(gulp.dest(dstGlob))
    .pipe filelog()

#圧縮系
gulp.task 'cssmin', ->
    gulp.src [distCss + '/*.css']
        .pipe concat('style.css')
        .pipe cssmin()
        .pipe gulp.dest(buildCss)

gulp.task 'jsmin', ->
    gulp.src [distJs + '/*.js']
        .pipe uglify(preserveComments: 'some')
        .pipe gulp.dest(buildJs)

gulp.task 'jsBundle', ->
    gulp.src ['./src/js/lib/*.js']
        .pipe concat('bundle.min.js')
        .pipe uglify(preserveComments: 'some')
        .pipe gulp.dest(distJs + '/lib')

gulp.task 'buildJsBundle', ->
    gulp.src (distJs + '/lib/bundle.min.js')
        .pipe gulp.dest('build/js/lib/')

gulp.task 'htmlprettify', ->
    gulp.src(DEST + '/*.html')
        .pipe prettify({indent_size: 2})
        .pipe gulp.dest('./build')


gulp.task 'json', ->
    gulp.src('src/data/*.json')
        .pipe jsonminify()
        .pipe gulp.dest('./build/data')

gulp.task 'distjson', ->
    gulp.src ('src/data/*.json')
        .pipe jsonminify()
        .pipe gulp.dest('dist/data')

gulp.task 'copyimg', ->
    gulp.src ('src/img/**')
        .pipe gulp.dest('dist/img')

gulp.task 'imgclean', ->
    del(['dist/img/*.+(jpg|jpeg|png|gif|svg)','dist/img/**/*.+(jpg|jpeg|png|gif|svg)'])

gulp.task 'cleanDir', ->
    del('./build/*')

gulp.task 'watch', ->
    gulp.watch [stylusPath + '/*.styl',stylusPath + '/_partial/*.styl'], ['stylusReload']
#    gulp.watch ['src/ejs/**/*.ejs', 'src/ejs/**/_*.ejs'], ['ejsReload','htmlhint','htmlprettify']
    gulp.watch ['src/jade/**/*.jade', 'src/jade/**/_*.jade'], ['jadeReload','htmlhint','htmlprettify']
    gulp.watch ['src/js/*.js'], ['jsReload']
    gulp.watch ['src/js/lib/*.js'], ['jsBundle' ,'bsReload']
    gulp.watch ['src/img/*.+(jpg|jpeg|png|gif|svg)','src/img/**/*.+(jpg|jpeg|png|gif|svg)'], ['imgclean','copyimg']


#task
#gulp.task 'default', ['watch', 'browserSync','copyimg','distjson','jsBundle']
gulp.task 'default', (callback) ->
    runSequence 'stylusReload','jadeReload','jsReload',
                ['watch', 'browserSync','copyimg','distjson','jsBundle'], callback


#delが上手くいかない時があるのでエラーが出たら再度叩く
gulp.task 'build', (callback) ->
    runSequence 'imgclean',
                ['imagemin','cssmin','jsmin','htmlprettify','json','buildJsBundle'], callback

#build
#cleanDir,imgclean
#一旦build以下を削除,dist以下の画像を削除
#imagemin,
#dist,buildにsrc以下の画像を圧縮
#cssmin,jsmin,htmlprettify
#dist以下のファイルをミニファイしてbuild以下に
#json
#src以下のjsonファイルをミニファイしてbuild以下に
#buildJsBundle
#dist/js/lib/bundle.min.jsをbuild以下にコピー


