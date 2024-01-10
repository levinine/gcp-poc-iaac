sudo apt-mark hold openssh-server
sudo sed "s/.*nrconf{restart}.*/\$nrconf{restart} = \'a\';/" /etc/needrestart/needrestart.conf > tmp-nr.conf &&
mv tmp-nr.conf /etc/needrestart/needrestart.conf

sudo apt update && sudo apt upgrade -y
sudo apt install tinyproxy -y > startup_log.txt

sudo sed '/^Allow 127.0.0.1$/a\
Allow localhost
' /etc/tinyproxy/tinyproxy.conf > tmp-proxy.conf && mv tmp-proxy.conf /etc/tinyproxy/tinyproxy.conf
sudo service tinyproxy restart