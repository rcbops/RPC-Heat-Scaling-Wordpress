install-iptables:
  pkg.installed:
    - pkgs:
      - iptables

{% for key,rule in salt['pillar.get']('user-ports',{}).items() %}

user-ports-{{key}}:

  iptables.append:
    - table: filter
    - chain: {{rule.get('chain', 'INPUT')}}
    - jump: ACCEPT
    - match: state
    - connstate: NEW
{% if rule.get('source') %}
    - source: {{rule.get('source')}}
{% endif %}
    - dport: {{rule.get('dport')}}
    - proto: {{rule.get('proto', 'tcp')}}
    - sport: 1025:65535
    - save: True
{% endfor %}

allow established:
  iptables.append:
    - table: filter
    - chain: INPUT
    - match: state
    - connstate: ESTABLISHED
    - jump: ACCEPT
    - save: True

default to drop:
  iptables.set_policy:
    - table: filter
    - chain: INPUT
    - policy: DROP

# Restart salt minion
restart salt-minion:
  cmd.wait:
    - name: echo service salt-minion restart | at now + 1 minute
    - watch:
      - iptables: default to drop
