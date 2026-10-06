{
  config,
  pkgs,
  ...
}: let
  dataDir = "${config.home.homeDirectory}/.local/share/claude-telemetry";
  logDir = "${config.home.homeDirectory}/Library/Logs/claude-telemetry";

  promConfig = pkgs.writeText "prometheus.yml" ''
    global:
      scrape_interval: 1m
  '';

  lokiConfig = pkgs.writeText "loki.yaml" ''
    auth_enabled: false
    server:
      http_listen_address: 127.0.0.1
      http_listen_port: 3100
      grpc_listen_address: 127.0.0.1
      grpc_listen_port: 9096
    common:
      path_prefix: ${dataDir}/loki
      replication_factor: 1
      instance_addr: 127.0.0.1
      ring:
        kvstore:
          store: inmemory
      storage:
        filesystem:
          chunks_directory: ${dataDir}/loki/chunks
          rules_directory: ${dataDir}/loki/rules
    schema_config:
      configs:
        - from: "2024-01-01"
          store: tsdb
          object_store: filesystem
          schema: v13
          index:
            prefix: index_
            period: 24h
    limits_config:
      allow_structured_metadata: true
      retention_period: 17520h
    compactor:
      working_directory: ${dataDir}/loki/compactor
      retention_enabled: true
      delete_request_store: filesystem
    analytics:
      reporting_enabled: false
  '';

  provisioning = pkgs.linkFarm "grafana-provisioning" [
    {
      name = "datasources/prometheus.yaml";
      path = pkgs.writeText "prometheus-ds.yaml" ''
        apiVersion: 1
        datasources:
          - name: Prometheus
            uid: prometheus
            type: prometheus
            url: http://127.0.0.1:9090
            isDefault: true
          - name: Loki
            uid: loki
            type: loki
            url: http://127.0.0.1:3100
      '';
    }
    {
      name = "dashboards/claude.yaml";
      path = pkgs.writeText "claude-dashboards.yaml" ''
        apiVersion: 1
        providers:
          - name: claude
            type: file
            options:
              path: ${./telemetry-dashboards}
      '';
    }
  ];
in {
  home.sessionVariables = {
    CLAUDE_CODE_ENABLE_TELEMETRY = "1";
    OTEL_METRICS_EXPORTER = "otlp";
    OTEL_EXPORTER_OTLP_PROTOCOL = "http/protobuf";
    OTEL_EXPORTER_OTLP_METRICS_ENDPOINT = "http://127.0.0.1:9090/api/v1/otlp/v1/metrics";
    OTEL_LOGS_EXPORTER = "otlp";
    OTEL_EXPORTER_OTLP_LOGS_ENDPOINT = "http://127.0.0.1:3100/otlp/v1/logs";
    # skill names live in tool arguments
    OTEL_LOG_TOOL_DETAILS = "1";
    # Prometheus OTLP ingest rejects delta temporality
    OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE = "cumulative";
  };

  home.activation.claudeTelemetryDirs = config.lib.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p ${dataDir}/prometheus ${dataDir}/grafana ${dataDir}/loki ${logDir}
  '';

  launchd.agents.claude-prometheus = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.prometheus}/bin/prometheus"
        "--config.file=${promConfig}"
        "--storage.tsdb.path=${dataDir}/prometheus"
        "--storage.tsdb.retention.time=2y"
        "--web.listen-address=127.0.0.1:9090"
        "--web.enable-otlp-receiver"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "${logDir}/prometheus.log";
      StandardErrorPath = "${logDir}/prometheus.log";
    };
  };

  launchd.agents.claude-loki = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.grafana-loki}/bin/loki"
        "-config.file=${lokiConfig}"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "${logDir}/loki.log";
      StandardErrorPath = "${logDir}/loki.log";
    };
  };

  launchd.agents.claude-grafana = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.grafana}/bin/grafana"
        "server"
        "--homepath=${pkgs.grafana}/share/grafana"
      ];
      EnvironmentVariables = {
        GF_PATHS_DATA = "${dataDir}/grafana";
        GF_PATHS_LOGS = logDir;
        GF_PATHS_PROVISIONING = "${provisioning}";
        GF_SERVER_HTTP_ADDR = "127.0.0.1";
        GF_AUTH_ANONYMOUS_ENABLED = "true";
        GF_AUTH_ANONYMOUS_ORG_ROLE = "Admin";
        GF_AUTH_DISABLE_LOGIN_FORM = "true";
        GF_ANALYTICS_REPORTING_ENABLED = "false";
        GF_ANALYTICS_CHECK_FOR_UPDATES = "false";
      };
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "${logDir}/grafana.log";
      StandardErrorPath = "${logDir}/grafana.log";
    };
  };
}
