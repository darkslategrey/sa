require 'mina/bundler'
# require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'deploy'
set :deploy_to, '/home/ks304579/public_html/sa'
set :repository, 'git@github.com:darkslategrey/sa.git'
set :branch, 'master'

# set :ssh_options, "export RACK_ENV"
# #{File.open(".env").readlines.map(&:chomp).join(" ")}}

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log']


# task :env do
#   queue %[RACK_ENV="production"]
# end

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'
  set :rvm_path, '/usr/local/rvm/scripts/rvm'

  set_default :rails_env, 'production'    
  set_default :bundle_prefix, lambda { %{RACK_ENV="#{rails_env}" #{bundle_bin} exec} }
  set :bundle_options, lambda { %{--without development --path "#{bundle_path}" --binstubs bin/ --deployment}}
    # %{--without development:test --path "#{bundle_path}" --binstubs bin/ --deployment}

  set_default :rake, lambda { %{#{bundle_prefix} rake} }
  
  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-2.1.0@sa]'
  invoke :'rvm:wrapper[ruby-2.1.0@sa,sa,bundle]'
  invoke :'rvm:wrapper[ruby-2.1.0@sa,rake,rake]'  
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'

    queue! "#{rake} db:migrate"

    # queue "%[rake js:minify]"
    # invoke :'rails:rake:db_migrate'
    # invoke :'rails:assets_precompile'

    to :launch do
      queue! "sed -i '/SUBSTITUTE FOR DEPLOY/ s/url: /url: document.location.pathname + /' #{deploy_to}/current/public/js/app/app.js public/js/app/view/UserListPanel.js"
      queue! "sed -i '/SUBSTITUTE FOR DEPLOY/ s/appFolder: /appFolder: document.location.pathname + /' #{deploy_to}/current/public/js/app/app.js"
      queue! 'sed -i "/SUBSTITUTE FOR DEPLOY/ s/\(AxAgenda\x22:\)/\1 document.location.pathname +/"' + " #{deploy_to}/current/public/js/app/app.js"
      queue! 'sed -i "/SUBSTITUTE FOR DEPLOY/ s,\x22Extensible\x22:,// Extensible\x22:,"' + " #{deploy_to}/current/public/js/app/app.js"
      queue! 'sed -i -e "/Extensible.js/d" -e "s/extensible-all-debug.js/extensible-all.js/"' + " #{deploy_to}/current/views/html/head.haml"
      queue! 'sed -i "/extensible-all.js/ s/-# //"' + " #{deploy_to}/current/views/html/head.haml"
      
      queue "chown -R www-data.www-data #{deploy_to}/current/ #{deploy_to}/shared/log"
      queue "ln -s #{deploy_to}/tmp #{deploy_to}/current/tmp"
      queue "touch #{deploy_to}/tmp/restart.txt"
    end
  end
end


# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

