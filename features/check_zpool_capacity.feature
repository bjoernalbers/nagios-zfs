Feature: Check zpool capacity

  In order to sleep well
  As the "data storage guy"
  I want to check the used capacity of my ZFS storage pools.

  Background:
    Given the zpool "tank" has a capacity of 80%

  Scenario: Critical threshold reached
    When I run `check_zpool -p tank -w 79 -c 80`
    Then the status should be critical

  Scenario: Warning threshold reached
    When I run `check_zpool -p tank -w 80 -c 81`
    Then the status should be warning

  Scenario: Capacity below thresholds
    When I run `check_zpool -p tank -w 81 -c 82`
    Then the status should be ok

  Scenario: Display actual capacity
    When I run `check_zpool -p tank -w 81 -c 82`
    Then the stdout should contain "80%"

  #NOTE: This currently does not work!
  #Scenario: Unknown zpool name
    #When I run `check_zpool -p foo -w 81 -c 82`
    #Then the status should be unknown
    #And the stdout should contain "unknown zpool foo"

