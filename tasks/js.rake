


namespace :js do

  desc "generate bootstrap.js file"
  task :bootstrap do
    js_dir = 'public/js'
    out = %x(sencha compile -classpath=#{js_dir}/extensible/src,#{js_dir}/extjs/src,#{js_dir}/app meta -alias -out #{js_dir}/build/bootstrap.js and meta -alt -append -out #{js_dir}/build/bootstrap.js)
    puts out
  end

  desc "compile"
  task :compile do
    # marche pas !
    # sencha compile -classpath=public/js/extensible/src,public/js/extjs/src,public/js/app exclude -f '*/Extensible.js' and page -yui -in public/index.html -out public/js/build/index.html    
    %x(sed '/haml/d' views/html/head.haml > /tmp/head.haml; haml /tmp/head.haml public/index.html)
  end

end
