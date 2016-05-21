base:

  'roles:scaling-wordpress-web':
    - match: grain
    - scaling_wordpress.galera
    - scaling_wordpress.web
    - scaling_wordpress.sync

  'roles:scaling-wordpress-haproxy':
    - match: grain
    - scaling_wordpress.haproxy
