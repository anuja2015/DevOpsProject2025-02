### Install Prometheus

      sudo apt update
      wget https://github.com/prometheus/prometheus/releases/download/v2.53.4/prometheus-2.53.4.linux-amd64.tar.gz
      tar -xvf prometheus-2.53.4.linux-amd64.tar.gz
      cd prometheus-2.53.4.linux-amd64
      ./prometheus &

#### Access at <ip-address>:9090

### Install Grafana

      sudo apt-get install -y adduser libfontconfig1 musl
      wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.6.0_amd64.deb
      sudo dpkg -i grafana-enterprise_11.6.0_amd64.deb
      sudo /bin/systemctl start grafana-server

  #### Access at <ip-address>:3000
