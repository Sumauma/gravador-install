Linux versions supported: Centos 8 Stream or ORACLE LINUX 8.8(OL8.8) install:

DVD ISO:
keyboard: Portuguese Brazil
language: ENglish USA
Time and Date: Americas/Sao Paulo
Software Selection: Server with development tools, headless management, System Tools
Kdump disabled


AFTER INSTALL, BOOT VM AND DO SSH TO IT AND RUN THE COMMANDS BELOW:

dnf update
dnf install epel-release 

1) DISABLE SELINUX:
vi /etc/selinux/config
change from SELINUX=enforcing to SELINUX=disabled
systemctl stop firewalld.service
systemctl disable firewalld.service
iptables -F
iptables -F -t nat
vi /etc/ssh/sshd_config
procure por: GSSAPIAuthentication yes
troque por: GSSAPIAuthentication no
salve pressionando :x <enter>

reboot


3) baixar os pacotes de instalacao do gravador e arquivos de configuracao:
cd /
git clone --depth 1 https://github.com/Sumauma/gravador-install.git /root2
cd /root2
cp -ax * /root
rm -rf /root2


4) instalar o Java JDK:

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
Procure por:
<TrackerHostname>localhost</TrackerHostname>
Mude o "localhost" para o endereço ip da interface, é o endereco ip que o Tomcat vai rodar.

8) vamos configurar pra auto iniciar o orkaudio e o tomcat ao bootar:
cd /etc/init.d
chkconfig --add tomcat
chkconfig tomcat on
systemctl enable tomcat
 
 9) instalar e configurar o MYSQL:
 dnf install mysql-server
 systemctl enable mysqld.service
 systemctl start mysqld.service
agora vamos definir a senha do usuário root do MySQL rodando o comando abaixo, cadastra a senha que voce quiser, anote pois será usado nos próximos passos:
 mysql_secure_installation -> Would you like to setup VALIDATE PASSWORD component? No
Remove anonymous users? Yes
Disallow root login remotely? No
Remove test database and access to it? Yes
Reload privilege tables now? Yes
 
mysql -p <enter>

mysql> create database cdrs;
Query OK, 0 rows affected (0.00 sec)

mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';
Query OK, 0 rows affected (0.00 sec)

mysql> UPDATE mysql.user SET host='%' WHERE user='root';
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
mysql> quit

cd /root/
mysql -p cdrs < mysql-cdrs.sql

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

agora vamos configurar no Tomcat o endereço ip e senha que está rodando o MySQL server instalado no item anterior, vamos usar a senha que foi cadastrada pro usuário root:
vi web.xml 
trocar na url abaixo o localhost pelo endereco ip da interface que está rodando o MySQL server:
<context-param>
        <param-name>jdbcURL</param-name>
        <param-value>jdbc:mysql://localhost/cdrs</param-value>
</context-param>
trocar a senha da variavel jdbcPassword(senha cadastrada no usuario root do MySQL)

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

14)vamis iniciar o Tomcat server:
service tomcat start

deverá listar umas linhas indicando que o Tomcat foi iniciado com sucesso:


15) criar a aplicacao Docker do PCAP sniffer chamado Oreka Orkaudio:
    
sudo docker run -d --net=host --restart=always --privileged=true -v /var/log/orkaudio:/var/log/orkaudio  -v /etc/orkaudio:/etc/orkaudio sumauma/orkaudio:latest 

Esse comando irá retornar o hash do container id criado, vide exemplo abaixo:
[root@localhost ~]# sudo docker run -d --net=host --restart=always --privileged=true -v /var/log/orkaudio:/var/log/orkaudio -v /etc/orkaudio:/etc/orkaudio sumauma/orkaudio:latest
70e63eef740c02bf5be8b8c909d733b2055dca519ec473751015cb6f98ad4914


16) vamos verificar se os 12 primeiros caracteres do hash acima batem com o id do container ao rodar o comando que lista os containers ativos do docker:
    docker container ls
    Exemplo:
    [root@localhost ~]# docker container ls
    CONTAINER ID   IMAGE                     COMMAND                  CREATED         STATUS         PORTS     NAMES
    70e63eef740c   sumauma/orkaudio:latest   "/opt/entrypoint.sh …"   8 seconds ago   Up 8 seconds             flamboyant_merkle   

Como podemos ver do item 15 o hash gerado foi: 70e63eef740c02bf5be8b8c909d733b2055dca519ec473751015cb6f98ad4914
E o container id do comando acima foi:         70e63eef740c
Isso quer dizer que o container foi criado com sucesso e ainda está rodando.

18) Para verificar se o container esta rodando a aplicacao "orkaudio" com sucesso, vamos ver nos logs da aplicacao se a interface de rede foi conectada com sucesso para realizar PCAP dos pacotes:
    a) cd /var/log/orkaudio
    b) less orkaudio.log
    c) Procure no inicio do arquivo pela ocorrencia da frase: "Successfully opened device. pcap handle"
    d) se aparecer é porque a aplicacao "orkaudio" que está rodando no container docker, conseguiu abrir a interface de rede do host e ativou o PCAP sniffer
    e) exemplo:
    [root@localhost ~]# less /var/log/orkaudio/orkaudio.log
2024-05-22 00:22:10,311  INFO root:264 - 

OrkAudio version : service starting

2024-05-22 00:22:10,322  INFO root:109 - Loaded plugin: /usr/lib/libvoip.so
2024-05-22 00:22:10,326  INFO packet:1847 - Initializing VoIP plugin
2024-05-22 00:22:10,327  INFO packet:1554 - Available pcap devices:
2024-05-22 00:22:10,327  INFO packet:1561 - * ens192 - 
2024-05-22 00:22:10,327  INFO packet:1353 - Setting pcap socket buffer size:67108864 bytes successful
2024-05-22 00:22:10,366  INFO packet:1377 - Activating pcaphandle:421a5fc0 successfully
2024-05-22 00:22:10,366  INFO packet:1392 - Setting setsockopt with bufsize:8388608 successfully
2024-05-22 00:22:10,367  INFO packet:1484 - Successfully opened device. pcap handle:421a5fc0 message:
    
19) se tudo estiver OK de um reboot:
reboot

20) fique testando ping e tente dar TELNET Ou NCAT nas portas 8080(Tomcat) e 5090(SIP/udp ou tcp):

telnet ip-gravador 8080
telnet ip-gravador 5090

se nao conectar entra e limpa o firewall:
iptables -F
iptables -F -t nat

21) agora que está tudo rodando voce pode acessar a interface web do gravador pra ver as gravacoes:
 http://192.168.40.249:8080/orktrack/ (substituir o endereço ip para o endereco do servidor em questao)
   
22) se o Tomcat nao subir na porta 8080 apos um reboot ou rodando o comando: service tomcat start
va ate o diretorio: 
cd sumauma-siprec-server
apague o arquivo de pid e tente iniciar o Tomcat novamente:
rm tomcat.pid

23) as gravacoes WAV ficam em pastas dentro do diretorio: /var/log/orkaudio
    as pastas sao formadas por ano, mes, dia, hora da gravacao.
    
