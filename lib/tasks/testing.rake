Rake::TestTask.new(:minitest => "test:prepare") do |t|
  t.libs << "test"
  t.pattern = 'test/**/*_{test,spec}.rb'
end

Rake.application.instance_variable_get('@tasks')['default'].prerequisites.delete('test')
task :default => :minitest
