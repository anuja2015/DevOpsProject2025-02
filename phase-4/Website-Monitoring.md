### Install Prometheus

      sudo apt update
      wget https://github.com/prometheus/prometheus/releases/download/v2.53.4/prometheus-2.53.4.linux-amd64.tar.gz
      tar -xvf prometheus-2.53.4.linux-amd64.tar.gz
      cd prometheus-2.53.4.linux-amd64
      ./prometheus &

#### Access at ip-address:9090

### Install Grafana

      sudo apt-get install -y adduser libfontconfig1 musl
      wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.6.0_amd64.deb
      sudo dpkg -i grafana-enterprise_11.6.0_amd64.deb
      sudo /bin/systemctl start grafana-server

  #### Access at ip-address:3000    initial username: admin password: admin

  ### Install Blackbox exporter

  #### The Blackbox Exporter is a Prometheus exporter that allows you to probe endpoints (e.g., HTTP, HTTPS, TCP, ICMP) over the network — from outside the service, like a user would — and expose the resulting metrics to Prometheus.

        wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.26.0/blackbox_exporter-0.26.0.linux-amd64.tar.gz
        tar -xvf blackbox_exporter-0.26.0.linux-amd64.tar.gz
        cd blackbox_exporter-0.26.0.linux-amd64
        ./blackbox_exporter &
        
 #### Access at ip-address:9115

 ### Update prometheus.yml with scrape configs

             - job_name: 'blackbox'
                metrics_path: /probe
                params:
                  module: [http_2xx]  # Look for a HTTP 200 response.
                static_configs:
                  - targets:
                    - http://40.121.142.142:30902 # Target to probe with http on port 8080.
                relabel_configs:
                  - source_labels: [__address__]
                    target_label: __param_target
                  - source_labels: [__param_target]
                    target_label: instance
                  - target_label: __address__
                    replacement: 172.172.233.172:9115  # The blackbox exporter's real hostname:port.

### Restart prometheus

      pgrep prometheus # gives processid
      kill -9 processid
      ./prometheus &
      
![image](https://github.com/user-attachments/assets/816a5cad-42bc-4f48-ae7b-bdf0a94b8c8b)

![image](https://github.com/user-attachments/assets/f6adb1ac-0115-4ca8-9564-95781e59e025)

### Add prometheus as data source on Grafana

![image](https://github.com/user-attachments/assets/67405ecb-c9cd-41c9-b39f-6d54e874e255)

![image](https://github.com/user-attachments/assets/efe7702d-8577-4258-9e8b-47552dc52869)

![image](https://github.com/user-attachments/assets/bf2d7448-eb50-4203-9fcb-2899497fc2b8)

### Import dashboard

![image](https://github.com/user-attachments/assets/c3699200-423b-44be-8b71-d0a40eb90d70)

![image](https://github.com/user-attachments/assets/eae54a8a-003b-434e-9b3b-9fe332d577c5)

![image](https://github.com/user-attachments/assets/b4bc8ff9-e963-4e4b-97b1-781f4e9811a3)

7587

![image](https://github.com/user-attachments/assets/3ddccf24-c011-40c1-8fe4-61b7adb8b873)

![image](https://github.com/user-attachments/assets/be31b45d-b7b1-4f96-8d07-a34d2583beaf)

![image](https://github.com/user-attachments/assets/b7feb2bf-c302-42fd-961a-d46f4ea02806)








