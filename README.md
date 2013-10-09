# Nagios-ZFS

Check ZFS Zpool health and capacity via Nagios.

## Installation

Install it via RubyGems:

    $ gem install nagios-zfs

## Usage

Nagios-ZFS provices ships with a binary to check the status of your ZFS
Zpools.

    $ check_zpool --help

A Zpool is in a critical state if the pool capacity jumps over a certain
rate (performance usually starts to suck at 80%) or when the pool is
faulted.
The status will be warning if your Zpool is degraded or if the capacity
breaks your warning threshold.
Take a look at the
[features](https://github.com/bjoernalbers/nagios-zfs/tree/master/features)
...

This plugin works successfully under Oracle Solaris 11 (ZFS VERSION:
11.11,REV=2009.11.11).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2013 Björn Albers
