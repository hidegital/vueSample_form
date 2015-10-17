gulp       = require 'gulp'
watch      = require 'gulp-watch'
fs         = require 'fs'

browserify = require 'browserify'
watchify   = require 'watchify' #browserifyのコンパイルを早くする
uglify     = require 'gulp-uglify' #js圧縮
source     = require 'vinyl-source-stream' #gulp で Browserify を扱う際に利用
buffer     = require 'vinyl-buffer'
transform  = require 'vinyl-transform'
assign     = require 'lodash.assign'

consolidate   = require 'gulp-consolidate' #gulpfileの変数をテンプレートエンジンで使用するためのモジュール


browserSync = require 'browser-sync'
reload = browserSync.reload;

data = require 'gulp-data'
plumber = require 'gulp-plumber' #エラー時に止めない

#sass = require 'gulp-sass'
#sass = require 'gulp-ruby-sass' #node-sass rubyのsass, stylusとどれ使うか,win用
stylus = require 'gulp-stylus'
koutoSwiss = require 'kouto-swiss'
pleeease = require 'gulp-pleeease' #autoprefixer
csscomb = require 'gulp-csscomb'
cssmin = require 'gulp-cssmin'
#scsslint = require 'gulp-scss-lint'
csslint = require 'gulp-csslint'
sourcemaps = require 'gulp-sourcemaps'

babelify = require 'babelify'

ejs = require 'gulp-ejs'
jade = require 'gulp-jade'
htmlhint = require 'gulp-htmlhint'
prettify = require 'gulp-prettify'

sitemap = require 'gulp-sitemap'

del = require 'del'
runSequence = require 'run-sequence'
header  = require 'gulp-header'

coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
uglify  = require 'gulp-uglify'
jsonminify = require 'gulp-jsonminify'
#imagemin
imagemin = require 'gulp-imagemin'


#imageResize
changed     = require 'gulp-changed'
filelog     = require 'gulp-filelog'
imageResize = require 'gulp-image-resize'


#AUTOPREFIXER_BROWSERS = [
#    'ie >= 10',
#    'ff >= 30',
#    'chrome >= 34',
#    'safari >= 7',
#    'opera >= 23',
#];

jsSrcPath         = './src/js'
distJs            = './dist/js'
buildJs           = './build/js'
scssPath          = './src/scss'
stylusPath        = './src/stylus'
distCss           = './dist/css'
buildCss          = './build/css'

#bootstrapScssPath = './bootstrap/assets/stylesheets'
srcImg            = './src/img'
#distImg           = './dist/img'
buildImg          = './build/img'

#jsonData = require './src/data/index.json'

#json
ejsJson = require 'gulp-ejs-json'

#sprite
spritesmith = require 'gulp.spritesmith'

gutil = require 'gulp-util'
_ = require 'underscore'
DEST = './dist'
SRC = './src'


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


customOpts =
    entries: ["#{SRC}/js/app.js"]
    debug: true
opts = _.extend {}, watchify.args, customOpts
b = watchify browserify(opts)
b.transform 'babelify', { compact: false }
bundle = ->
    b.bundle().on 'error',  gutil.log.bind gutil, 'Browserify Error'
    .pipe source './js/app.js'
    .pipe buffer()
    .pipe gulp.dest DEST
gulp.task 'js', bundle
b.on 'update', bundle

gulp.task 'js', bundle
b.on 'update', bundle
b.on 'log', gutil.log

gulp.task 'jsReload', (callback) ->
    runSequence 'js', 'bsReload', callback

#customOpts =
#    entries: [ './src/js/app.js' ]
#    debug: true
#opts = assign({}, watchify.args, customOpts)
#b = watchify(browserify(opts))
#bundle = ->
#    b.bundle().on('error', gutil.log.bind(gutil, 'Browserify Error'))
#        .pipe(source('app.js')).pipe(buffer())
#        .pipe(sourcemaps.init(loadMaps: true))
#        .pipe(sourcemaps.write('./'))
#        .pipe gulp.dest('./dist/js/')
#gulp.task 'js', bundle
#b.on 'update', bundle
#b.on 'log', gutil.log


# srcから受け取ったファイルをbrowserifyして
# 返す関数を定義
#gulp.task 'js', ->
#    browserified = transform((filename) ->
#        b = browserify(filename)
#        b.add filename
#        b.bundle()
#    )
#    gulp.src('src/js/*.js')
#        .pipe(browserified)
#        .pipe uglify()
##        .pipe($.sourcemaps.init(loadMaps: true))
##        .pipe($.sourcemaps.write('./map'))
#        .pipe gulp.dest('./js/dist/')


#paths =
#    js: ["#{SRC}/**/*.js"]

#gulp.task 'browserify', ->
#    browserify(debug: true)
#    .transform(babelify)
#    .require('src/js/app.js', entry: true)
#    .bundle()
#    .on('error', (err) ->
#        console.log 'Error: ' + err.message
#        return
#    ).pipe fs.createWriteStream('bundle.js')

gulp.task 'browserSync', ->
    browserSync
        notify: false,
        port: 3000,
        server: {
            baseDir: ['./dist/']
        }

#やはりstylusのがよさそう
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
    .pipe (gulp.dest('./dist/css/'))


gulp.task 'stylusReload', (callback) ->
  runSequence 'stylus', 'bsReload', callback


#  sass使うときは上記の用にrunSequenceで直列にする
gulp.task 'sass', ->
    return sass './src/scss/',{sourcemap: true}
#  gulp.src ['src/scss/*.scss','!' + 'src/scss/**/_*.scss'] gulp-sassでの書き方
#    .pipe sass()
    .pipe plumber()
    .pipe pleeease(
        minifier: false,
        autoprefixer: {"browsers": ["last 4 versions"]}
    )
    .pipe csscomb()
    .pipe(sourcemaps.write())
#    .pipe scsslint()
    .on('error', console.error.bind(console))
    .pipe (header('@charset "utf-8";\n'))
    .pipe (gulp.dest('./dist/css/'))

gulp.task 'csslint', ->
    gulp.src(distCss + '/*.css')
        .pipe csslint()
        .pipe csslint.reporter()

consolidateOptions =
    pathName: 'test'

gulp.task 'jade', ->
    gulp.src ["src/jade/**/*.jade",'!' + "src/jade/**/_*.jade"]
        .pipe(data((file) ->
            require './src/data/list.json'
        ))
        .pipe consolidate 'jade',
            consolidateOptions
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

gulp.task 'bsReload', ->
    browserSync.reload()

#sprite
gulp.task 'spriteStylus', ->
    spriteData = gulp.src 'src/img/sprite/*.png'
    .pipe plumber()
    .pipe spritesmith
        imgName: 'sprite.png',
        cssName: 'sprite.styl',
        cssFormat: 'stylus'
    spriteData.img
    .pipe gulp.dest(srcImg +  '/sprite/')
    .pipe gulp.dest('dist/img/')
    spriteData.css
    .pipe gulp.dest(stylusPath + '/_partial');

#gulp.task 'spriteSass', ->
#    spriteData = gulp.src srcImg + '/sprite/*.png'
#    .pipe plumber()
#    .pipe spritesmith
#        imgName: 'sprite.png',
#        cssName: '_sprite.scss',
#        cssFormat: 'scss'
#    spriteData.img
#    .pipe gulp.dest(srcImg + '/sprite/')
#    .pipe gulp.dest('dist/img/')
#    spriteData.css
#    .pipe gulp.dest(scssPath + '/partial/')

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

#concat順番通りになってる？？
gulp.task 'cssmin', ->
    gulp.src [distCss + '/*.css']
        .pipe concat('style.css')
        .pipe cssmin()
        .pipe gulp.dest(buildCss)

gulp.task 'jsmin', ->
    gulp.src [distJs + '/*.js']
        .pipe uglify()
        .pipe gulp.dest(buildJs)

gulp.task 'jsBundle', ->
    gulp.src ['./src/js/lib/*.js']
        .pipe concat('bundle.min.js')
        .pipe uglify()
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


gulp.task 'watch', ->
#    gulp.watch scssPath + '/*.scss', ['sass','bsReload']
#    gulp.watch scssPath + '/*.scss', ['sass','csslint','bsReload']
    gulp.watch [stylusPath + '/*.styl',stylusPath + '/_partial/*.styl'], ['stylusReload']
#    gulp.watch ['src/ejs/**/*.ejs', 'src/ejs/**/_*.ejs'], ['ejsReload','htmlhint','htmlprettify']
    gulp.watch ['src/jade/**/*.jade', 'src/jade/**/_*.jade'], ['jadeReload','htmlhint','htmlprettify']
    gulp.watch ['src/js/*.js'], ['jsReload']
    gulp.watch ['src/js/lib/*.js'], ['jsBundle' ,'bsReload']


#TODO clean dell使う？？ sitemap生成試す
gulp.task 'default', ['watch', 'browserSync','copyimg','distjson','jsBundle']
gulp.task 'dist', ['copyimg','distjson','jsBundle']
gulp.task 'lint', ['csslint']
gulp.task 'build', ['imagemin','cssmin','jsmin','htmlprettify','json','buildJsBundle']







