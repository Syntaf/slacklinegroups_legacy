require 'fileutils'

namespace :minify do
  desc "Minifies slacklinegroups widget and updates public file (with dep)"
  task :slg => :environment do
    require 'uglifier'
    
    out = Rails.root.join('public', 'slacklinegroups.min.js')
    slg = Rails.root.join('vendor', 'slacklinegroups.js')
    
    res = Uglifier.new.compile(File.read(slg))
    # => js file minified
    File.open(out, 'w') {|f| f.write(res) }

    rainbowSrc = Rails.root.join('vendor', 'rainbow-custom.min.js')
    rainbowDest = Rails.root.join('public', 'rainbow-custom.min.js')

    FileUtils.cp(rainbowSrc, rainbowDest)
  end
end
