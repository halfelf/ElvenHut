task :default => :test

task :my_site do 
  ruby 'setup.rb'
  ruby 'route.rb'
end

task :test do
  require 'rake/testtask'
  Rake::TestTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/*_test.rb']
    t.verbose = false
    t.warning = true
  end
end

