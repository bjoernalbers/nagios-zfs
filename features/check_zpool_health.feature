Feature: Check zpool health

  In order to sleep well
  As the "data storage guy"
  I want to check the health of my ZFS storage pools.

  Scenario Outline:
    Given the zpool "tank" has a capacity of 80%
      And  the health from zpool "tank" is "<health>"
    When I run `check_zpool -p tank -w 81 -c 82`
    Then the status should be <status>
      And the stdout should contain "<health>"

    Examples:
      | health   | status   |
      | FAULTED  | critical |
      | DEGRADED | warning  |
      | ONLINE   | ok       |
      | SICK     | unknown  |
