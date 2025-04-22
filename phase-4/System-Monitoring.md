### Install node-exporter

    wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz
    tar -xvf node_exporter-1.9.1.linux-amd64.tar.gz
    cd node_exporter-1.9.1.linux-amd64/
    ./node_exporter &


### Add in prometheus.yml

     - job_name: 'node_exporter'
        static_configs:
            - targets: [57.154.240.166:9100]
      - job_name: 'worker02'
        metrics_path: '/prometheus'
        static_configs:
          - targets: [57.154.240.166:8080]

