Centos 8 Stream install:

DVD ISO:
keyboard: Portuguese Brazil
language: ENglish USA
Time and Date: Americas/Sao Paulo
Software Selection: Server with development tools, headless management, RPM development, System Tools, Power Tools
Kdump disabled


AFTER INSTALL, BOOT VM AND DO SSH TO IT AND RUN THE COMMANDS BELOW:

dnf update
dnf groupinfo "Development Tools"
dnf group install "Development Tools"
dnf groupinfo "Power Tools"
dnf group install "Power Tools"
dnf install centos-release-stream -y --allowerasing
dnf install epel-release 

1) DISABLE SELINUX:
vi /etc/selinux/config
change from SELINUX=enforcing to SELINUX=disabled
systemctl stop firewalld.service
systemctl disable firewalld.service
iptables -F
iptables -F -t nat


2) baixar os pacotes de instalacao do gravador e arquivos de configuracao:
cd /
git clone --depth 1 https://github.com/Sumauma/gravador-install.git /root2
cd /root2
cp -ax * /root
rm -rf /root2


3) instalar o Java JDK:

download jdk-8u202-linux-x64.rpm from Oracle and place it on /root:
abrir no chrome: https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html

fazer um scp para a VM no dir /root

logar na VM e cd /root
a)rpm -ivh jdk-8u202-linux-x64.rpm

b)alternatives --config java
select the jdk-8u202 as the default alternative

c) check if the correct version of java is running:
java -version
Response:
java version "1.8.0_202"
Java(TM) SE Runtime Environment (build 1.8.0_202-b08)
Java HotSpot(TM) 64-Bit Server VM (build 25.202-b08, mixed mode)


4) copiar os arquivos de configuracao do ORKAUDIO:
cd /root/etc
mkdir /etc/orkaudio
cp * /etc/orkaudio
5) copiar os arquivos de inicializacao do ORKAUDIO e do TOMCAT:
cd /root/init.d
cp * /etc/init.d
6) editar o arquivo abaixo e verificar se o path do JDK do JAVA esta correto no dir /usr/java:
ls /usr/java
cp bash-profile-do-usuario-root-gravador.txt /root/.bash_profile

7) configurar a interface de rede que vai sniffar os pacotes SIP/RTP(mirror de pcap):
cd /etc/orkaudio
vi config.xml
Procure por:
<Devices>eth1</Devices>
Mude para o nome da sua placa de rede no linux:
<Devices>enp0s3</Devices>

8) vamos configurar pra auto iniciar o orkaudio e o tomcat ao bootar:
cd /etc/init.d
chkconfig --add tomcat
chkconfig tomcat on
systemctl enable tomcat
 
 9) instalar e configurar o MYSQL:
 dnf install mysql-server
 systemctl enable mysqld.service
 systemctl start mysqld.service
 mysql_secure_installation
 
mysql -p
create database cdrs;
quit
cd /root/
mysql -p cdrs < mysql-cdrs.sql
quit

10) criar o diretorio onde os arquivos de audio das gravacoes serao armazenados localmente para posterior envio pra um NAS ou nuvem:
mkdir /var/log/orkaudio

11) configurar no TOMCAT o endereco ip e porta que o TOMCAT ira ficar ouvindo por INVITEs SIPREC:

cd /root/sumauma-siprec-server/webapps/orktrack/WEB-INF

editar os arquivos: web.xml e sip.xml para mudar senha e ip do servidor.

vi sip.xml
procurar por:
<context-param>
        <param-name>ip.address</param-name>
        <param-value>10.3.0.5</param-value>
</context-param>
trocar pelo endereco ip da interface que vai ouvir pelas requisicoes SIP
vi web.xml 
trocar na url abaixo o localhost pelo endereco ip da interface:
<context-param>
        <param-name>jdbcURL</param-name>
        <param-value>jdbc:mysql://localhost/cdrs</param-value>
</context-param>
trocar a senha da variavel jdbcPassword

trocar o usuario da variavel jdbcUsername

12) 
cd /root/sumauma-siprec-server/conf

vi server.xml
procurar por 5090:
trocar: 
ipAddress = "10.3.0.5"
pelo:
ipAddress = "seu endereco da interface que vai escutar por conexoes SIP REC"

13) instalacao do DOCKER:
instalar o docker e rodar a nossa app docker de gravacao:
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin --allowerasing --nobest

sudo systemctl enable docker
sudo systemctl start docker
cd /root
14) criar a aplicacao Docker do Orkaudio para se inicializar sempre que a VM reiniciar:
sudo docker run -it --net=host --restart=always --privileged=true -v /var/log/orkaudio:/var/log/orkaudio  -v /etc/orkaudio:/etc/orkaudio sumauma/orkaudio:latest 

15) abrir outro terminal e rebootar a VM e verificar se subiu tudo.

16) se o Tomcat nao subir na porta 8080 apos um reboot ou rodando o comando: service tomcat start
va ate o diretorio: 
cd sumauma-siprec-server
apague o arquivo de pid e tente iniciar o Tomcat novamente:
rm tomcat.pid


