require File.expand_path('../../environment', __FILE__)

RSpec.configure do |config|
  config.before :each do
    Shearwater::SpecSupport::MigrationTracker.clear!
  end
end
