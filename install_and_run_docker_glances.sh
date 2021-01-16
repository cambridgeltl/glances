sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt-get install docker-ce docker-ce-cli containerd.io

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo apt update
sudo apt install nvidia-docker2
sudo systemctl restart docker

systemctl restart docker
wget https://raw.githubusercontent.com/cambridgeltl/glances/develop/glances-docker.service -O /etc/systemd/system/glances-docker.service
systemctl enable glances-docker
systemctl start glances-docker
echo "======================================================"
echo "Now the Docker is installed as a root user, which will affect the its usage for a non-root user."
echo "For managing Docker as a non-root user, please configure your Linux hosts refering to:"
echo "https://docs.docker.com/engine/install/linux-postinstall/"
echo "======================================================"
