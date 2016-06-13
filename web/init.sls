{% from "scaling_wordpress/web/wordpress.jinja2" import wordpress with context %}
web-software:
  pkg.installed:
    - pkgs:
      - gcc
      - make
      - apache2
      - php5
      - php5-mysql
      - php-apc
      - php-pear

wordpress-archive:
  archive.extracted:
    - name: /var/www/
    - source: {{ wordpress.url }}
    - source_hash: md5={{ wordpress.md5 }}
    - archive_format: tar
    - tar_options: z
    - if_missing: /var/www/wordpress
    - require:
      - pkg: web-software

  file.managed:
    - name: /var/www/wordpress/wp-config.php
    - source: salt://scaling_wordpress/web/files/wp-config.php.jinja2
    - template: jinja

/etc/apache2/sites-enabled/000-default.conf:
 file.absent

# Make wordpress vhost available
/etc/apache2/sites-available/000-wordpress.conf:
  file.managed:
    - source: salt://scaling_wordpress/web/files/000-wordpress.conf.jinja2
    - template: jinja
    - require:
      - pkg: web-software

/etc/apache2/sites-enabled/000-wordpress.conf:
  file.symlink:
    - target: /etc/apache2/sites-available/000-wordpress.conf

apache-service:
  service.running:
    - name: apache2
    - enable: True
    - require:
      - pkg: web-software
    - watch:
      - file: /etc/apache2/sites-enabled/000-default.conf
      - file: /etc/apache2/sites-enabled/000-wordpress.conf
