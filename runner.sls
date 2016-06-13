saltutil.sync_all:
  salt.function:
    - tgt: '*'

saltutil.refresh_pillar:
  salt.function:
    - tgt: '*'

mine.update:
  salt.function:
    - tgt: '*'
    - require:
      - salt: saltutil.refresh_pillar

identify_bootstrap:
  salt.state:
    - tgt: 'roles:scaling-wordpress-galera'
    - tgt_type: grain
    - sls:
      - scaling_wordpress.galera.identify_bootstrap
    - require:
      - salt: mine.update

bootstrap_cluster:
  salt.state:
    - tgt: 'is_bootstrap:True'
    - tgt_type: grain
    - sls:
      - scaling_wordpress.galera
    - require:
      - salt: identify_bootstrap

cmd.run:
  salt.function:
    - tgt: roles:scaling-wordpress-galera
    - tgt_type: grain
    - arg:
      - sleep 30
    - require:
      - salt: bootstrap_cluster

finish_cluster:
  salt.state:
    - tgt: 'is_bootstrap:False'
    - tgt_type: grain
    - sls:
      - scaling_wordpress.galera
    - require:
      - salt: cmd.run

web:
  salt.state:
    - tgt: 'roles:scaling-wordpress-web'
    - tgt_type: grain
    - sls:
      - scaling_wordpress.web
    - require:
      - salt: finish_cluster

haproxy:
  salt.state:
    - tgt: 'roles:scaling-wordpress-haproxy'
    - tgt_type: grain
    - sls:
      - scaling_wordpress.haproxy

hardening:
  salt.state:
    - tgt: '*'
    - sls:
      - scaling_wordpress.hardening
    - require:
      - salt: haproxy
      - salt: web
      - salt: finish_cluster
