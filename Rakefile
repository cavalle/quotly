require "rubygems"

require "spec"
require "spec/rake/spectask"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(--format specdoc --colour)
  t.libs = ["spec"]
end

task :default => ["spec"]

task :deploy do
  sh "ssh cirrus.lmcavalle.com 'cd chef; sudo chef-solo -c config/solo.rb -j config/node.json'"
end