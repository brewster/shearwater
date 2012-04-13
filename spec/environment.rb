require 'bundler'

Bundler.require(:default, :test)

Dir.glob(File.join(File.dirname(__FILE__), 'support', '**', '*.rb')).each do |f|
  require f
end
