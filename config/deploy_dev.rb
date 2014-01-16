require 'mina/bundler'
require 'mina/git'
require 'mina/rvm'

set :domain, 'deploy'
set :deploy_to, '/home/ks304579/public_html/sa-dev'
set :repository, 'git@github.com:darkslategrey/sa.git'
set :branch, 'master'

set :shared_paths, ['config/database.yml', 'log']

task :environment do
  set :rvm_path, '/usr/local/rvm/scripts/rvm'

  set_default :rails_env, 'development'    
  set_default :bundle_prefix, lambda { %{RACK_ENV="#{rails_env}" #{bundle_bin} exec} }
  set :bundle_options, lambda { %{--without development --path "#{bundle_path}" --binstubs bin/ --deployment}}
  set_default :rake, lambda { %{#{bundle_prefix} rake} }
  invoke :'rvm:use[ruby-2.1.0@sa]'
  invoke :'rvm:wrapper[ruby-2.1.0@sa,sa,bundle]'
  invoke :'rvm:wrapper[ruby-2.1.0@sa,rake,rake]'  
end

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
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    queue! "#{rake} db:migrate"

    to :launch do
      queue! "sed -i '/SUBSTITUTE FOR DEPLOY/ s/url: /url: document.location.pathname + /' #{deploy_to}/current/public/js/app/app.js public/js/app/view/UserListPanel.js"
      queue! "sed -i '/SUBSTITUTE FOR DEPLOY/ s/appFolder: /appFolder: document.location.pathname + /' #{deploy_to}/current/public/js/app/app.js"
      queue! 'sed -i "/SUBSTITUTE FOR DEPLOY/ s/\(AxAgenda\x22:\)/\1 document.location.pathname +/"' + " #{deploy_to}/current/public/js/app/app.js"
      queue! 'sed -i "/SUBSTITUTE FOR DEPLOY/ s,\x22Extensible\x22:,// Extensible\x22:,"' + " #{deploy_to}/current/public/js/app/app.js"
      queue! 'sed -i -e "/Extensible.js/d" -e "s/extensible-all-debug.js/extensible-all.js/"' + " #{deploy_to}/current/views/html/head.haml"
      queue! 'sed -i "/extensible-all.js/ s/-# //"' + " #{deploy_to}/current/views/html/head.haml"
      # queue! "ln -sf #{deploy_to}/current/public/js/extjs/ext.js #{deploy_to}/current/public/js/extjs/ext-all.js"
      queue! "chown -R www-data.www-data #{deploy_to}/current/"
      queue! "ln -s #{deploy_to}/tmp #{deploy_to}/current/tmp"
      queue! "touch #{deploy_to}/tmp/restart.txt"
    end
  end
end

desc "Setup the dev env"
task :setup_dev => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    queue! "#{rake} db:setup_dev"
    queue! "#{rake} db:migrate"
    queue! "#{rake} db:attach_user"
  end
end

