{% from "scaling_wordpress/galera/galera.jinja2" import galera with context %}
debconf-utils:
  pkg.installed:
    - require_in:
      - debconf: mariadb-preseed

mariadb-preseed:
  debconf.set_file:
    - source: salt://scaling_wordpress/galera/files/galera.preseed.jinja2
    - template: jinja
    - require_in:
      - pkg: mariadb-galera-server

mariadb-repo:
  pkgrepo.managed:
    - comments:
      - '# MariaDB 10.0 Ubuntu repository list - managed by salt {{ grains['saltversion'] }}'
      - '# http://mirror.jmu.edu/pub/mariadb/repo/10.0/ubuntu'
    - name: deb http://ftp.utexas.edu/mariadb/repo/10.0/ubuntu precise main
    - dist: trusty
    - file: {{ salt['pillar.get']('scaling-wordpress:mdb_repo:file') }}
    - keyserver: {{ salt['pillar.get']('scaling-wordpress:mdb_repo:keyserver') }}
    - keyid: '{{ salt['pillar.get']('scaling-wordpress:mdb_repo:keyid') }}'
    - require_in:
      - pkg: mariadb-galera-server

mariadb-galera-server:
  pkg.installed

python-mysqldb:
  pkg.installed

/etc/mysql/my.cnf:
  file.managed:
    - source: salt://scaling_wordpress/galera/files/my.cnf.jinja2
    - template: jinja
    - require:
      - pkg: mariadb-galera-server

/root/.my.cnf:
  file.managed:
    - source: salt://scaling_wordpress/galera/files/root.cnf
    - template: jinja
    - mode: 600

mysql-service:
  service.running:
    - name: mysql
    - require:
      - pkg: mariadb-galera-server
    - watch:
      - file: /etc/mysql/my.cnf

{% if galera.is_bootstrap %}
cluster_started:
  grains.present:
    - value: True
    - required:
      - service: mysql-service
{% endif %}

wordpress_db:
  mysql_database.present:
    - name: {{ galera.db_name }}
    - connection_default_file: /root/.my.cnf

  mysql_user.present:
    - name: {{ galera.db_username }}
    - password: {{ galera.db_password }}
    - host: {{ galera.db_host }}
    - connection_default_file: /root/.my.cnf

  mysql_grants.present:
    - user: {{ galera.db_username }}
    - grant: all privileges
    - database: {{ galera.db_username }}.*
    - host: {{ galera.db_host }}
    - connection_default_file: /root/.my.cnf
