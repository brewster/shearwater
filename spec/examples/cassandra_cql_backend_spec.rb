require File.expand_path('../spec_helper', __FILE__)
require 'shearwater/cassandra_cql_backend'

class CassandraStubResults
  def initialize(row_hashes)
    @row_hashes = row_hashes
  end

  def fetch
    @row_hashes.each do |row_hash|
      yield row_hash
    end
  end
end

describe Shearwater::CassandraCqlBackend do
  describe "#last_migration" do
    it "ignores 'range ghosts' when identifying the last migration" do
      connection = stub('connection')
      stubbed_cassandra_results = CassandraStubResults.new([
        { 'version' => 1, 'migrated_at' => 2342342 },
        { 'version' => 2, 'migrated_at' => nil }
      ])
      connection.stub_chain(:execute).and_return(stubbed_cassandra_results)
      backend = Shearwater::CassandraCqlBackend.new(connection)
      backend.last_migration.should == 1
    end
  end
end
