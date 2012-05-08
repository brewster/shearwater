require File.expand_path('../lib/shearwater/version', __FILE__)
require 'rspec/core/rake_task'

task :default => :release
task :release => [:build, :tag, :update_stable, :push, :cleanup]

desc 'Build gem'
task :build do
  system 'gem build shearwater.gemspec'
end

desc 'Create git release tag'
task :tag do
  system "git tag -a -m 'Version #{Shearwater::VERSION}' #{Shearwater::VERSION}"
  system "git push origin #{Shearwater::VERSION}:#{Shearwater::VERSION}"
end

desc 'Update stable branch on GitHub'
task :update_stable do
  if Shearwater::VERSION =~ /^(\d+\.)+\d+$/ # Don't push for prerelease
    system "git push -f origin HEAD:stable"
  end
end

desc 'Push gem to repository'
task :push => :inabox

task 'Push gem to geminabox'
task :inabox do
  system "gem inabox shearwater-#{Shearwater::VERSION}.gem"
end

task 'Remove packaged gems'
task :cleanup do
  system "rm -v *.gem"
end

desc 'Run the specs'
RSpec::Core::RakeTask.new(:test)
