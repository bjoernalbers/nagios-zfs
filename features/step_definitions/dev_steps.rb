Given(/^the zpool "(.*?)" has a capacity of (\d+)%$/) do |name, capacity|
  cmd = "zpool list -H -o name,cap #{name}"
  out = "#{name}\t#{capacity}%\n"
  double_cmd(cmd, :puts => out)
end

Then(/^the status should be (unknown|critical|warning|ok)$/) do |status|
  exit_status =
    case status
    when 'unknown'  then 3
    when 'critical' then 2
    when 'warning'  then 1
    when 'ok'       then 0
    end
  steps %Q(
    Then the exit status should be #{exit_status}
    And the stdout should contain "#{status.upcase}"
  )
end
