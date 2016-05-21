base:
  'roles:scaling-wordpress-haproxy':
    - match: grain
    - scaling_wordpress

  'roles:scaling-wordpress-web':
    - match: grain
    - scaling_wordpress

  'roles:scaling-wordpress-galera':
    - match: grain
    - scaling_wordpress
