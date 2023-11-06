Insper - SuperComputação 

Roteiro - Criação do Cluster 

 

PARTE 1 - INSTALAÇÃO DOS SOFTWARES NECESSÁRIOS


Você deverá montar a sua Maquina Host principal, SSD, M2, memorias e Sistema Operacional Ubuntu Desktop 22.04 LTS.


Instalar os seguintes softwares: 

Virtualbox – a versão utilizada nesse roteiro foi a versão 7.0.10, disponível em https://www.virtualbox.org/wiki/Downloads 

Oracle VM VirtualBox Extension Pack - faça download do extension pack do VirtualBox, compatível com a versão instalada do Virtualbox. O link fica na mesma página de download do VirtualBox.  

Vagrnat – Vagrant é uma ferramenta que possibilita automatizar os processos de criação e manutenção de máquinas virtuais. Faça o download da versão mais recente em https://developer.hashicorp.com/vagrant/downloads?product_intent=vagrant  

 

PARTE 2 – SETUP DA VM PRINCIPAL – SYSTEM MANAGEMENT SERVER (SMS) 

Nosso cluster será formado por uma máquina principal (System Management Server – SMS) e duas máquinas de processamento (compute-00 e compute-01). Nós iniciamos criando a máquina principal, configurando os softwares necessários e criando nela também a imagem das máquinas de processamento, as quais serão criadas posteriormente.  

Faremos boa parte dos comandos por meio do Vagrant. Para isso, ele precisa de um arquivo Vagrantfile que contém as instruções necessárias para subir a máquina virtual. O arquivo Vagrantfile que vamos usar é o https://raw.githubusercontent.com/brattex/hpc-ecosystems-openhpc101/master/student/Vagrantfile 

Faça download dele e salve em uma pasta do seu computador. Escolha essa pasta com cuidado, pois o Vagrant vai compartilhar essa pasta com as máquinas virtuais. Isso vai nos ajudar bastante para transferir arquivos entre a nossa máquina física e a máquina virtual.  

Nessa mesma pasta, faça download do arquivo setenv.c, disponível em https://raw.githubusercontent.com/brattex/hpc-ecosystems-openhpc101/master/student/setenv.c. Esse arquivo é um arquivo que deve ser executado logo ao entrar na máquina virtual, pois ele define as variáveis de ambiente fundamentais para o processo de configuração das máquinas.  

Estando na pasta que você definiu anteriormente, e garantindo que você instalou todos os softwares e que possui nessa pasta os dois arquivos (Vagrantfile e setenv.c), faça os seguintes passos: 

Em um terminal (prompt de comando), digite: vagrant up  

O comando anterior vai ler os parâmetros que estão no arquivo Vagrantfile, criar a máquina virtual, fazendo download e instalação de uma imagem do CentOS na máqiina virtual. Atente-se que essa imagem de CentOS é a versão 7.7 64-bit e seu tamanho é de aproximadamente 400MB.  

Uma vez criada a máquina, você pode entrar nela por meio do comando vagrant ssh 

Após digitar o comando anterior, você está na máquina criada. A seguir executaremos uma série de comandos nessa máquina. Para facilitar, indicaremos no início da linha de código a máquina que você deve executar: [SMS] é a máquina virtual criada (o controlador do cluster) e [HOST] é a sua máquina física.  

Aqui está uma visão de todos os softwares que iremos instalar e configurar: 

Nagios - fornecerá métricas e análises básicas do cluster. 

Ganglia - fornecerá métricas e análises básicas do cluster. 

ClusterShell - usado para executar comandos em paralelo entre nós do cluster - muito útil para testar e avaliar a funcionalidade do cluster. 

Node Health Check (NHC) - executa uma verificação periódica em cada nó de computação para verificar se o nó está em boas condições de funcionamento. 

Identificação de arquivos para sincronização por xCAT - sincronização de arquivos base do host SMS para os nós de computação gerenciados. 


   13  sinfo
   14  scontrol update nodename=compute00 state=IDLE
   15  scontrol update nodename=compute01 state=IDLE
   16  sinfo