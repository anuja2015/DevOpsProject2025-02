
### Steps to be performed on Master Node

#### 1. Disable swap

      swapoff -a
      sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

#### 2. Forwarding IPv4 and letting iptables see bridged traffic

#### it enables proper network communication between pods across nodes

      cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
       
        overlay
        
        br_netfilter
      
      EOF
      
      sudo modprobe overlay
      
      sudo modprobe br_netfilter

      # sysctl params required by setup, params persist across reboots
      
      cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
      
        net.bridge.bridge-nf-call-iptables  = 1
        
        net.bridge.bridge-nf-call-ip6tables = 1
        
        net.ipv4.ip_forward                 = 1
      
      EOF

      # Apply sysctl params without reboot
      
      sudo sysctl --system

      # Verify that the br_netfilter, overlay modules are loaded by running the following commands:
      
      lsmod | grep br_netfilter
      
      lsmod | grep overlay

      # Verify that the net.bridge.bridge-nf-call-iptables, net.bridge.bridge-nf-call-ip6tables, and net.ipv4.ip_forward system variables are set to 1 in your sysctl config by running the following command:
      
      sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

#### 3. Install container runtime

#### containerd sits above the runc, and adds a bunch of features, like transferring images, storage, and networking. It also fully supports the OCI spec.

    curl -LO https://github.com/containerd/containerd/releases/download/v1.7.14/containerd-1.7.14-linux-amd64.tar.gz
    
    sudo tar Cxzvf /usr/local containerd-1.7.14-linux-amd64.tar.gz
    
    curl -LO https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
    
    sudo mkdir -p /usr/local/lib/systemd/system/
    
    sudo mv containerd.service /usr/local/lib/systemd/system/
    
    sudo mkdir -p /etc/containerd
    
    containerd config default | sudo tee /etc/containerd/config.toml
    
    sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
    
    sudo systemctl daemon-reload
    
    sudo systemctl enable --now containerd

      # Check that containerd service is up and running
    
    systemctl status containerd

#### 4. Install runc

#### runc is a low-level container runtime. It uses the native features of Linux to create and run containers. It follows the OCI standard, and it includes libcontainer, a Go library for creating containers.

    curl -LO https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64
    
    sudo install -m 755 runc.amd64 /usr/local/sbin/runc

#### 5. Install CNI plugins

#### they provide the networking infrastructure for pods and services within the cluster.

    curl -LO https://github.com/containernetworking/plugins/releases/download/v1.5.0/cni-plugins-linux-amd64-v1.5.0.tgz
    
    sudo mkdir -p /opt/cni/bin
    
    sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.5.0.tgz

#### 6. Install kubeadm, kubectl and kubelet

      sudo apt-get update
      
      sudo apt-get install -y apt-transport-https ca-certificates curl gpg

      curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
      
      echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

      sudo apt-get update
      
      sudo apt-get install -y kubelet=1.30.10-1.1 kubeadm=1.30.10-1.1 kubectl=1.30.10-1.1 --allow-downgrades --allow-change-held-packages
      
      sudo apt-mark hold kubelet kubeadm kubectl

      kubeadm version
      
      kubelet --version
      
      kubectl version --client

#### 7. Configure crictl to work with containerd

    sudo crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock

#### 8. Initialize control-plane 

      sudo kubeadm init --pod-network-cidr=192.68.0.0/16 --apiserver-advertise-address=172.0.1.6 --node-name master-node

- pod-network-cidr should match with networking addons used. Here I am using calico and hence using this cidr.
- 
- apiserver-advertise-address should be private address of the master node.

#### 9. Prepare kubeconfig

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

__Note:__ These commands will be displayed once control-plane is successfully initialized.

#### 10. Install calico

#### Calico is a networing addon which  provides the underlying networking and security for the cluster's pods and nodes.

    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml

    curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml -O

    kubectl apply -f custom-resources.yaml


### Steps to be performed on worker nodes

#### Repeat steps __1__ to __7__ on worker nodes

#### 8. Join the worker nodes to the cluster

    kubeadm join 172.0.1.6:6443 --token 0tgyzw.i5dxeho5rz159ko4 \
        --discovery-token-ca-cert-hash sha256:e32c7a5237c4321e6fb6eb339e2198e12f2482f9f8dc8493de17d1a36757434e

#### __Note__ If you forgot to copy the command, you can execute below command on master node to generate the join command again

        kubeadm token create --print-join-command

#### Verify the cluster using kubectl commands

      kubectl get pods -A
      kubectl get nodes

      ![image](https://github.com/user-attachments/assets/e568f607-37eb-4e72-8121-a7a8512424f8)
      ![image](https://github.com/user-attachments/assets/dd2ff243-6f52-433f-8573-ad0448111570)




