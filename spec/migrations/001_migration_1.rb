class Migration1
  def up
    Shearwater::SpecSupport::MigrationTracker.migrated!(1)
  end

  def down
    Shearwater::SpecSupport::MigrationTracker.rolled_back!(1)
  end
end
