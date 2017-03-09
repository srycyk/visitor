#! /usr/bin/env ruby

    #ROOT = 'post/'
    ROOT = ''
    PU = ROOT + 'vendor/plugins/'
    LIB = ROOT + 'lib/'
    DB = ROOT + 'db/'
    CONF = ROOT + 'config/'
    APP = ROOT + 'app/'
    TEST = ROOT + 'test/'
    SPEC = ROOT + 'spec/'
    CUCUMBER = ROOT + 'features/'

    verbose = true
    verbose = ARGV.size == 0
    verbose = false
    
    files = []

    pusher = lambda {|list, file| list.push file if File.file? file }

    if verbose
      #files += Dir[PU + '**/*.rb'].sort

      #files.push CONF + 'database.yml'
    end

    #files.push 'README.md'
    files.push 'Gemfile'

    files.push CONF + 'routes.rb'

    files += Dir[DB + 'migrate/*.rb'].sort

    #files.push DB + 'schema.rb'

    #files.push DB + 'database.yml'

    files += Dir[LIB + '**/*.rb'].sort

    %w(models controllers helpers).each do |subdir|    
      files += Dir[APP + "#{subdir}/**/*.rb"].sort
    end

    files += Dir[APP + "assets/javascripts/*.js"].sort

    files += Dir[APP + "assets/stylesheets/*.css*"].sort

    files += Dir[APP + "views/**/*.*"].grep(/[^~]$/).sort

    #files += Dir[APP + "html_views/**/*.*"].grep(/[^~]$/).sort

    files += Dir[SPEC + "models/**/*.rb"].grep(/[^~]$/).sort
    files += Dir[SPEC + "features/**/*.rb"].grep(/[^~]$/).sort
    files += Dir[SPEC + "factories/**/*.rb"].grep(/[^~]$/).sort
    files += Dir[SPEC + "support/*_support.rb"].grep(/[^~]$/).sort
    #files += Dir[SPEC + "fixtures/*.*"].grep(/[^~]$/).sort

    if verbose
      #files += Dir[TEST + "**/*.*"].sort

      #pusher.call files, 'public/stylesheets/scaffold.css'

      #files.push 'files.rb'

      #pusher.call files, 'x'
    end
    #pusher.call files, 'x'

    sep = ' '
    sep = ARGV.shift || ' '
    sep = "\n" if sep == 'n'

    print files.join(sep) + sep

