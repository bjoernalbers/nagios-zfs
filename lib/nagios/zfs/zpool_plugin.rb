module Nagios
  module ZFS
    class ZpoolPlugin < NagiosPlugin::Plugin
      include Mixlib::CLI

      option :zpool,
        :short => '-p ZPOOL_NAME',
        :long  => '--pool ZPOOL_NAME',
        :required => true

      option :critical,
        :short => '-c CRITICAL_CAPACITY',
        :long  => '--critical CRITICAL_CAPACITY',
        :proc  => Proc.new { |config| config.to_i }

      option :warning,
        :short => '-w WARNING_CAPACITY',
        :long  => '--warning WARNING_CAPACITY',
        :proc  => Proc.new { |config| config.to_i }

      def initialize
        super
        parse_options(argv)
      end

      def critical?
        critical_capacity?
      end

      def warning?
        warning_capacity?
      end

      # No explicite ok check.
      def ok?
        true
      end

      def message
        "#{zpool.name} #{zpool.capacity}%"
      end

    private

      def critical_capacity?
        zpool.capacity >= config[:critical]
      end

      def warning_capacity?
        zpool.capacity >= config[:warning]
      end

      def zpool
        @zpool ||= Zpool.new(config[:zpool])
      end

      # Array of command-line arguments
      #
      # This is only used for stubbing ARGV during tests which isn't so
      # easy with mixlib-cli.
      def argv
        ARGV
      end
    end
  end
end
