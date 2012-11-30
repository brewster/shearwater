require File.expand_path('../spec_helper', __FILE__)

describe Shearwater::Migrator do
  let(:backend) { Shearwater::InMemoryBackend.new }
  let(:tracker) { Shearwater::SpecSupport::MigrationTracker }

  let :migrator do
    Shearwater::Migrator.new(File.expand_path('../../migrations', __FILE__), backend)
  end

  describe '#migrate' do
    it 'should run all migrations from fresh' do
      migrator.migrate
      [1, 2, 3].each { |i| tracker.should have_migrated(i) }
    end

    it 'should run migrations in order of id' do
      migrator.migrate
      tracker.events.map(&:id).should == [1, 2, 3]
    end

    it 'should not run migrations that backend reports have already been run' do
      backend.migrated!(1)
      migrator.migrate
      tracker.events.map(&:id).should == [2, 3]
    end

    it 'should report run to backend' do
      migrator.migrate
      1.upto(3) { |i| backend.migrated?(i).should be_true }
    end
  end

  describe '#rollback' do
    context 'with previous migrations' do
      before(:each) do
        1.upto(3) { |i| backend.migrated!(i) }
      end

      it 'should roll back most recent change' do
        migrator.rollback
        tracker.should have_rolled_back(3)
        tracker.should_not have_rolled_back(2)
        tracker.should_not have_rolled_back(1)
      end

      it 'should mark migration as rolled back in backend' do
        migrator.rollback
        backend.migrated?(3).should be_false
      end

      it 'should run multiple migrations if passed' do
        migrator.rollback(2)
        tracker.should have_rolled_back(3)
        tracker.should have_rolled_back(2)
        tracker.should_not have_rolled_back(1)
      end
    end

    context 'without previous migrations' do
      it 'should silently succeed if no migrations left to rollback' do
        migrator.rollback
      end
    end
  end
end
