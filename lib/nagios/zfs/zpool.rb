module Nagios
  module ZFS
    class Zpool
      KNOWN_POOL_HEALTHS = %(ONLINE DEGRADED FAULTED)

      attr_reader :name

      def initialize(name)
        raise 'missing pool name' if [nil, ''].include?(name)
        @name = name
      end

      def capacity
        query.split("\t").last[/^(\d+)/,1].to_i
      end

      def query
        @query ||= `zpool list -H -o name,cap #{name}`
      end

      def health
        @health ||= `zpool list -H -o health #{name}`.strip
        raise "unknown health: #{@health}" unless
          KNOWN_POOL_HEALTHS.include?(@health)
        @health
      end
    end
  end
end
