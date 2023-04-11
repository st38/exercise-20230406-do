#!/usr/sbin/nft -f

{{/* Get all Address */}}
{{ range service "wireguard" -}}
  {{ scratch.Set "all_address" (sprig_cat (scratch.Get "all_address") .Address | trimSpace) }}
{{- end -}}

{{/* Get metrics Address */}}
{{ $env := parseJSON `["metrics"]` -}}
{{ $stage := parseJSON `["prod", "test"]` -}}
{{ range service "wireguard" -}}
  {{- if and (index .NodeMeta "env" | containsAny $env) (index .NodeMeta "stage" | containsAny $stage) -}}
    {{ scratch.Set "metrics_address" (sprig_cat (scratch.Get "metrics_address") .Address | trimSpace) }}
  {{- end -}}
{{- end -}}

define all_address = {{ if scratch.Get "all_address" }}{ {{ scratch.Get "all_address" | replaceAll " " ", " }} }{{ else }}{{ print "127.0.0.1" }}{{ end }}
define metrics_address = {{ if scratch.Get "metrics_address" }}{ {{ scratch.Get "metrics_address" | replaceAll " " ", " }} }{{ else }}{{ print "127.0.0.1" }}{{ end }}
define metrics_port = 9100
define logs_port = 5141

flush ruleset

# IPv4
table inet filter {

  # Input
  chain input {
    type filter hook input priority 0; policy drop;

    # invalid connections
    ct state invalid drop

    # established/related connections
    ct state established,related accept

    # loopback interface
    iifname lo accept

    # icmp
    icmp type echo-request accept comment "ICMP - Any"

    # tcp
    tcp dport 22 accept comment "SSH - Any"
    tcp dport 8301 accept comment "Consul TCP - Any"

    # udp
    udp dport 8301 accept comment "Consul UDP - Any"

    # metrics
    ip saddr $metrics_address tcp dport $metrics_port log accept comment "Node exporter - Metrics"

    # logs
    ip saddr $all_address tcp dport $logs_port log accept comment "Syslog - Any"
  }

  # Output
  chain output {
    type filter hook output priority 0; policy accept;
  }
}

# IPv6
table ip6 filter {

  chain input {
    type filter hook input priority 0; policy drop;

    # established/related connections
    ct state established,related accept

    # invalid connections
    ct state invalid drop

    # loopback interface
    iifname lo accept

    # icmp
    icmpv6 type {echo-request, nd-neighbor-solicit} accept comment "ICMP - Any"

    # tcp
    tcp dport 22 accept comment "SSH - Any"
    tcp dport 8301 accept comment "Consul TCP - Any"

    # udp
    udp dport 8301 accept comment "Consul UDP - Any"
  }

  # Output
  chain output {
    type filter hook output priority 0; policy accept;
  }
}
