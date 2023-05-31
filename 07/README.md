# 07. RPM

Размещаем свой RPM в своем репозитории

## Описание

* создать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями);

* создать свой репо и разместить там свой RPM;

* реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо.

## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Tutorial

### Создаем свой RPM - nginx с поддержкой openssl

```bash
vagrant up
vagrant ssh

sudo yum install -y \
  redhat-lsb-core \
  wget \
  rpmdevtools \
  rpm-build \
  createrepo \
  yum-utils \
  gcc

# --- загружаем nginx
wget https://nginx.org/packages/centos/8/SRPMS/nginx-1.20.2-1.el8.ngx.src.rpm
rpm -i nginx-1.*
# --- загружаем openssl
wget https://github.com/openssl/openssl/archive/refs/heads/OpenSSL_1_1_1-stable.zip
# tar -xvf latest.tar.gz - скачивается зип
unzip OpenSSL_1_1_1-stable.zip
# ---
ll

# ---  Заранее поставим все зависимости, чтобы в процессе сборки не было ошибок
sudo yum-builddep rpmbuild/SPECS/nginx.spec

vim rpmbuild/SPECS/nginx.spec
# добавляем опцию --with-openssl=/home/vagrant/openssl-OpenSSL_1_1_1-stable в ./configure
# и удаляем --with-debug

# --- собираем RPM
rpmbuild -bb rpmbuild/SPECS/nginx.spec

# --- проверяем
ll rpmbuild/RPMS/x86_64/

# --- устанавливаем пакет и проверяем работу
sudo yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el8.ngx.x86_64.rpm
sudo systemctl start nginx
sudo systemctl status nginx
```

### Создаем свой репозиторий

```bash
# --- создаем директорию для пакетов
sudo mkdir /usr/share/nginx/html/repo
# --- помещаем туда наш пакет и еще один из интернета
sudo cp rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el8.ngx.x86_64.rpm /usr/share/nginx/html/repo/
sudo wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.0.28/binary/redhat/8/x86_64/percona-orchestrator-3.2.6-2.el8.x86_64.rpm \
  -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-2.el8.x86_64.rpm
# ---
ll /usr/share/nginx/html/repo
# --- инициализируем репозиторий
sudo createrepo /usr/share/nginx/html/repo/

sudo vim /etc/nginx/conf.d/default.conf
# --- добавляем директиву autoindex on; в секцию "location /"
# --- проверяем синтаксис конфигурации
sudo nginx -t
# --- перезапускаем
sudo nginx -s reload
# --- проверяем
curl -a http://localhost/repo/

# --- добавляем наш новый репозиторий в "систему"
sudo -i
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
exit

# --- проверяем, что он есть
yum repolist enabled | grep otus

sudo yum install percona-orchestrator.x86_64 -y
```

