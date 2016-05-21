postfix-preseed:
  debconf.set_file:
    - source: salt://scaling_wordpress/hardening/files/postfix.preseed.jinja2
    - template: jinja

software-requirements:
  pkg.installed:
    - pkgs:
      - fail2ban
      - aide
      - logwatch

# Super work around for installing broken psad
install psad:
  cmd.wait:
    - name: echo  apt-get -q -y -o 'DPkg::Options::=--force-confold' -o 'DPkg::Options::=--force-confdef' install psad | at now + 1 minute
    - watch:
      - pkg: software-requirements

/etc/cron.daily/00logwatch:
  file:
    - managed
    - template: jinja
    - source: salt://scaling_wordpress/hardening/cron.daily/00logwatch
    - require:
      - pkg: software-requirements
