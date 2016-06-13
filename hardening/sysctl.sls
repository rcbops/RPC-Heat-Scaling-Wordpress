net.ipv4.icmp_echo_ignore_broadcasts:
  sysctl.present:
    - value: 1

net.ipv4.icmp_ignore_bogus_error_responses:
  sysctl.present:
  - value: 1

net.ipv4.tcp_syncookies:
  sysctl.present:
    - value: 1

net.ipv4.conf.all.log_martians:
  sysctl.present:
  - value: 1

net.ipv4.conf.default.log_martians:
  sysctl.present:
    - value: 1

net.ipv4.conf.all.accept_source_route:
  sysctl.present:
    - value: 0

net.ipv4.conf.default.accept_source_route:
  sysctl.present:
    - value: 0

net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 1

net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 1

net.ipv4.conf.all.accept_redirects:
  sysctl.present:
    - value: 0

net.ipv4.conf.default.accept_redirects:
  sysctl.present:
    - value: 0

net.ipv4.conf.all.secure_redirects:
  sysctl.present:
    - value: 0

net.ipv4.conf.default.secure_redirects:
  sysctl.present:
    - value: 0

net.ipv4.ip_forward:
  sysctl.present:
    - value: 0

net.ipv4.conf.all.send_redirects:
    sysctl.present:
    - value: 0

net.ipv4.conf.default.send_redirects:
  sysctl.present:
    - value: 0