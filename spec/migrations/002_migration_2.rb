class Migration2
  def up
    Shearwater::SpecSupport::MigrationTracker.migrated!(2)
  end

  def down
    Shearwater::SpecSupport::MigrationTracker.rolled_back!(2)
  end
end

