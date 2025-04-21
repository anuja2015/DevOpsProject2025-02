
### __Docker Installation__

    # Add Docker's official GPG key:
    
    sudo apt-get update
    
    sudo apt-get install -y ca-certificates curl
    
    sudo install -m 0755 -d /etc/apt/keyrings
    
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

      sudo apt-get update

        # install the latest version
        
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

### __Manage Docker as a non-root user__

        # Create docker group

            sudo groupadd docker
        # Add your user to the docker group
        
        sudo usermod -aG docker $USER

#### Log out and log back in so that your group membership is re-evaluated.

### SonarQube installation

    docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

#### Access at <vm-public-ip-address>:9000   Initial Username - admin Password - admin.

#### Pass word to be changed after login.

### Nexus installation

     docker run -d --name nexus -p 8081:8081 sonatype/nexus:latest

#### Access at <vm-public-ip-address>:8081  Initial Username - admin Password - /nexus-data/admin.password (inside the container).

![image](https://github.com/user-attachments/assets/c815db66-0acc-46a7-b40b-6be3f62267ac)


### Jenkins Installation

#### I am running my custom jenkins image.

        docker run -p 8080:8080 -p 50000:50000 -d --name myjenkins -u root -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock armdevu/custom-jenkins:1.0

#### Access at <vm-public-ip-address>:8080

