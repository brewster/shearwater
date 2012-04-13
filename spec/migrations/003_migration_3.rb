class Migration3
  def up
    Shearwater::SpecSupport::MigrationTracker.migrated!(3)
  end

  def down
    Shearwater::SpecSupport::MigrationTracker.rolled_back!(3)
  end
end
