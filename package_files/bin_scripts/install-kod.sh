#!/bin/bash
if [ `whoami` != "root" ]; then
    echo "sudo提权或使用root用户权限执行"
    exit 1
fi

if [ ! -f "/etc/debian_version" ]; then
    echo "老板，请使用ubuntu系统"
    exit 1
fi
local_ip=$(ifconfig eth0 | grep '\<inet\>'| grep -v '127.0.0.1' | awk '{ print $2}' | awk 'NR==1')
if [ -d /opt/kod ]; then
  rm -rf /opt/kod
fi
if [ -h /var/www/html/kod ]; then
  rm /var/www/html/kod
fi
mkdir -p /opt/kod
cd /opt/kod
wget https://static.kodcloud.com/update/download/kodbox.1.34.zip
unzip kodbox.1.34.zip && chmod -Rf 777 ./*
apt update
apt install php7.4-mbstring php7.4-gd php7.4-xml php7.4-curl -y
rm kodbox.1.34.zip
chmod -R 777 /opt/kod
ln -sf /opt/kod /var/www/html/kod
echo "可道云已安装，请浏览器打开 http://$local_ip/kod 进入设置。"
echo "如遇到问题，请在社区bbs.histb.com提出。"

cat <<EOF > /var/www/html/icons_wan/kod.html
<li>
    <a href="/kod/" target="_blank"><img class="shake" src="img/png/kod.png" /><strong>可道云</strong></a>
</li>
EOF
if [ ! -f /var/www/html/img/png/kod.png ]; then
  wget https://raw.hisi.ga/teasiu/histb/main/package_files/web/pre_files/common/var/www/html/img/png/kod.png -O /var/www/html/img/png/kod.png
fi