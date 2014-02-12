exports.config =
  # See docs at http://brunch.readthedocs.org/en/latest/config.html.
  conventions:
    assets:  /^app\/assets\/|^app\/components\//
    ignored: /^(bower_components\/bootstrap-less(-themes)?|app\/styles\/overrides|(.*?\/)?[_]\w*)/
  modules:
    definition: false
    wrapper: false
  paths:
    public: '_public'
    watched: ['app', 'test', 'vendor', 'app/components']
  files:
    javascripts:
      joinTo:
        'js/app.js': /^app/
        'js/vendor.js': /^(bower_components|vendor)/

    stylesheets:
      joinTo:
        'css/app.css': /^(app|vendor|bower_components)/
      order:
        before: [
          'app/styles/app.less'
        ]

    templates:
      joinTo:
        'js/dontUseMe' : /^app/ # dirty hack for Jade compiling.

  plugins:
    jade:
      pretty: yes # Adds pretty-indentation whitespaces to output (false by default)
    jade_angular:
      modules_folder: 'partials'
      locals: {}
    afterBrunch: [
      ''' 
        ## compile slim files
        ruby <<EOF
        path = 'app'
        Dir.glob("_public/**/*.slim") do |file|
          target = file.gsub( /\.slim$/, '')
          system "slimrb #{file} #{target}"
        end
        EOF
      ''',
      ''' 
        ## compile coffee files not compiled by brunch
        # until we figure out how to make brunch compile without concatenation.
        ruby <<EOF
        Dir.glob("_public/**/*.coffee") do |coffee_src|
          system "coffee -m -c #{coffee_src}"
        end
        EOF

        rsync -av app/assets/_locales _public/  # work around the prefix ignored by brunch
      ''',
      '''
        ## reload using Extension Reloader
        open -a 'google chrome canary' http://reload.extensions
        open -a 'google chrome canary' chrome-extension://capgjkioeanbjlbjjlkchildbfgchodl/_generated_background_page.html
      '''
    ]

  # Enable or disable minifying of result js / css files.
  minify: true

  overrides:
    production:
      paths:
        public: 'build'
        