install-at:
  pkg.installed:
    - pkgs:
      - at

  service.running:
   - name: atd
   - enable: True
