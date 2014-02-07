task :default => :loop

task :release => [ :build, :assemble, :zip ]

task :heroku => [ :build, :assemble, :'stage:heroku' ]

desc "loop"
task :loop do
  sh %(
    brunch watch --server -p 9001
  )
end

desc "build"
task :build do
  sh %(
    npm install
    bower install
    brunch build --production  # will build to _public
  )
end

desc "assemble"
task :assemble do
  sh %(
    # ## ship static/, app/data, .tmp/scripts/injectees
    # rsync -av static/* _public/
    # ## assume bbl-middleman is built, ship intro.
    # rsync -av ../bbl-middleman/build/webbuddy/intro _public/
  )
end

# desc "deploy to Google Drive"
# task :stage do
#   # copy the entire project to ease collaboration with designers
#   sh %(rsync -av --delete --exclude='.tmp' --exclude='.sass-cache' * "#{ENV['HOME']}/Google Drive/bigbearlabs/webbuddy-preview/webbuddy-plugins/")
# end

desc "deploy to bbl-rails on heroku"
task :'stage:heroku' do
  sh %(
    echo "## copy to webbuddy-extensions"
    rsync -av --delete --no-implied-dirs _public/* ../bbl-rails/public/webbuddy-extensions/
    cd ../bbl-rails
    echo "## commit"
    git add -A public/webbuddy-extensions
    git ci -a -m "updating webbuddy-extensions, #{Time.new.to_s}"
    git push heroku
    echo "## pushed to heroku"
  )
end

desc "zip extension"
task :zip => [] do
  releases_root = 'dist'
  zip_name = "webbuddy-extension-chrome.#{Time.new.to_i}.zip"
  target_dir = "_public"

  sh %Q(
    (
      cd #{target_dir}
      grep -v // manifest.json > manifest.json.scrubbed # remove comments from json
      mv manifest.json.scrubbed manifest.json
      zip -r #{zip_name} .
    )
    mv "#{target_dir}/#{zip_name}" #{releases_root}
  )
end


desc "clean"
task :clean do
  sh %(
    rm -rf _public
  )
end

desc 'bootstrap'
task :'bootstrap' do
  sh %(
    # needs npm, bower.
    npm install -g grunt-cli
    npm install -g grunt
    npm install -g brunch
    npm install
    bower install
  )
end
