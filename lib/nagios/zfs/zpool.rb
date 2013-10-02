module Nagios
  module ZFS
    class Zpool
      attr_reader :name

      def initialize(name)
        raise 'missing pool name' if [nil, ''].include?(name)
        @name = name
      end

      def capacity
        query.split("\t").last[/^(\d+)/,1].to_i
      end

      def query
        @query ||= `zpool list -H -o name,cap #{@name}`
      end
    end
  end
end
