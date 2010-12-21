module ActiveColumn

  module Tasks

    class Keyspace

      def initialize
        #@cassandra = ActiveColumn.connection
        c = ActiveColumn.connection
        @cassandra = Cassandra.new('system', c.servers, c.thrift_client_options)
      end

      def exists?(name)
        @cassandra.keyspaces.include? name.to_s
      end

      def create(name, options = {})
        ks = Cassandra::Keyspace.new
        ks.name = name.to_s
        ks.strategy_class = options[:strategy_class] || 'org.apache.cassandra.locator.LocalStrategy'
        ks.replication_factor = options[:replication_factor] || 1
        ks.cf_defs = []
        @cassandra.add_keyspace ks
      end

      def drop(name)
        @cassandra.drop_keyspace name.to_s
      end

      def set(name)
        @cassandra.keyspace = name.to_s
      end

      def get
        @cassandra.keyspace
      end

      def clear
        return puts 'Cannot clear system keyspace' if @cassandra.keyspace == 'system'

        @cassandra.clear_keyspace!
      end

    end

  end

end
