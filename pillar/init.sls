scaling-wordpress:
  galera:
    root_password: 'apassword'
    db:
      name: wordpress
      username: wordpress
      password: changeme

  mdb_repo:
    baseurl: http://mirror.jmu.edu/pub/mariadb/repo/10.0/ubuntu
    keyserver: hkp://keyserver.ubuntu.com:80
    keyid: '0xcbcb082a1bb943db'
    file: /etc/apt/sources.list

  wordpress:
    version: 4.5.2
    md5: 056da124260ed5b4465ec1fb2f9b7155
    AUTH_KEY: 'TGL9B6wnxW3xZO7b++1Q0Z/PQkIpH6NfnkxA0yzypmCQLD9RlR0xFJG/YvWiDm++NSMCFdfWKlXWe6yZ8vmaQw'
    SECURE_AUTH_KEY: 'XGPyqQdl76FICxpRAIwNlQ0SzHoBbP2SKzsyOvt2tslR38iApCgHUP/Ptt6KtGgNMwAI8b0v2YyJs/+gG8ZdEg'
    LOGGED_IN_KEY: '7dbvWyiUlFTi/BNr0qBVfGj973wh8ekxG6D9h/3j5x3ENbWcrRPoV9+3KFlgNn36svvpDIsprqCVxGtWLmbbNg'
    NONCE_KEY: 'UvHo2TVUeqvXz7QUUW5E1smyf8R3OSPr+FtlL/6E0jejYP+gorJgf3uoctF+8icB8EOZruyXZm4OZV51lY6Taw'
    AUTH_SALT: '49Yxbcqq7/3K4z4R/hi2+erimQ5fJab8U+1PRLK7s/dovXbKKC+I+TFWdavzkaQ9ZBQNvwKp4loiBbtTNDsYkQ'
    SECURE_AUTH_SALT: 'Suf1i0mcN0lFIgUiBnBUBNd2NkVpoZtytNRBNRQvnpRSpMk9mnATcHqghoEJ2RK5t/60ZAr0gUw0KMVBMOXoQQ'
    LOGGED_IN_SALT: '8/BDbThtuoHDhC4x8wsxjGyys6b3nYcgUUfBxM4cG0KkSKM/W9+hBg/1/btfsjHF0xUTuhOpJ+VKTvJ0UFZoiQ'
    NONCE_SALT: 'o5tJdo604Fnqvu6kEGSKu9nMaSD6HghfuWTDitvuUUMA4VVSh15L17yUBO73iz/owotPOSiwJgnRzT4RdioM+Q'

  sync:
    group: wordpress
    target: roles:scaling-wordpress-web
    expr_type: grain
    includes:
      - /var/www
    excludes:
      - /var/www/wordpress/wp-config.php

interfaces:
  public: eth0
  private: eth2

mine_functions:
  internal_ips:
    mine_function: network.ipaddrs
    interface: eth2
  external_ips:
    mine_function: network.ipaddrs
    interface: eth0
  id:
    - mine_function: grains.get
    - id
  host:
    - mine_function: grains.get
    - host

user-ports:
  ssh:
    chain: INPUT
    proto: tcp
    dport: 22
  salt-master:
    chain: INPUT
    proto: tcp
    dport: 4505
  salt-minion:
    chain: INPUT
    proto: tcp
    dport: 4506
  mysql:
    chain: INPUT
    proto: tcp
    dport: 3306
  galera_traffic_tcp:
    chain: INPUT
    proto: tcp
    dport: 4567
  galera_traffic_udp:
    chain: INPUT
    proto: udp
    dport: 4567
  galera_ist:
    chain: INPUT
    proto: TCP
    dport: 4568
  galera_sst:
    chain: INPUT
    proto: TCP
    dport: 4444
  http:
    chain: INPUT
    proto: tcp
    dport: 80
  https:
    chain: INPUT
    proto: tcp
    dport: 443
  lsyncd:
    chain: INPUT
    proto: tcp
    dport: 30865
