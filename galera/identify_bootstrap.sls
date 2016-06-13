{% from "scaling_wordpress/galera/galera.jinja2" import galera with context %}
is_bootstrap:
  grains.present:
    - value: {{ galera.is_bootstrap }}
