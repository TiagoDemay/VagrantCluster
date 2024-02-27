Insper - SuperComputação 

# Roteiro - Criação do Cluster 


## PARTE 1 - INSTALAÇÃO DOS SOFTWARES NECESSÁRIOS

Você deverá **montar** a sua Maquina Host principal, SSD, M2, memorias e Sistema Operacional Ubuntu Desktop 22.04 LTS.
**Atencao** : o Sistema Operacional acima deve ser instalado na NUC com a senha ClusterCluster e o usuario hpc (tudo padronizado).


### IMPORTANTE!

Antes de instalar os softwares e configurar o seu cluster, tenha certeza que seu sistema está atualizado e com headers do sistema operacional devidamente instalados, para isso:

``` bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install linux-headers-$(uname -r) -y 
```

Instalar os seguintes softwares: 

Virtualbox – a versão utilizada nesse roteiro foi a versão 7.0.12, disponível em https://www.virtualbox.org/wiki/Downloads 

Oracle VM VirtualBox Extension Pack - faça download do extension pack do VirtualBox, compatível com a versão instalada do Virtualbox. O link fica na mesma página de download do VirtualBox.  

Vagrant – Vagrant é uma ferramenta que possibilita automatizar os processos de criação e manutenção de máquinas virtuais. Faça o download da versão mais recente em https://developer.hashicorp.com/vagrant/downloads?product_intent=vagrant  

 

## PARTE 2 – SETUP DA VM PRINCIPAL – SYSTEM MANAGEMENT SERVER (SMS) 

Nosso cluster será formado por uma máquina principal (System Management Server – SMS) e duas máquinas de processamento (compute-00 e compute-01). 

Nós iniciamos criando a máquina principal, configurando os softwares necessários e criando nela também a imagem das máquinas de processamento, as quais serão criadas posteriormente.  

Faremos tudo isso de modo automatizado utilizando o vagrant. Crie uma pasta dentro da pasta Documentos de seu Sistema Operacional, recem instalado.
Clone o github  https://github.com/TiagoDemay/VagrantCluster.git que contém os arquivos base necessários para a criar as 3 maquinas e todos os softwares necessários para o funcionamento do nosso sistema de HPC (Computação de Alto Desempenho)

Estando na pasta que você definiu anteriormente, e garantindo que você instalou todos os softwares de pré requisitos, faça os seguintes passos: 

Em um terminal (prompt de comando), digite:

``` bash
vagrant up
``` 



O comando anterior vai ler os parâmetros que estão no arquivo Vagrantfile, criar a máquina virtual, fazendo download e instalação de uma imagem do CentOS na máquina virtual. Atente-se que essa imagem de CentOS é a versão 7.7 64-bit e seu tamanho é de aproximadamente 400MB.

### O script irá rodar, por cerca de 40 minutos.

## **Aproveite que o script está rodando e analise os 4 scripts e o arquivo Vagrant que esta no github clonado.**


### Agora que o ascript terminou, iremos iniciar os dois nós workers (compute00 e compute01), com a imagem que foi gerada pelo script via comando do CHROOT. 

Execute: 

``` bash
vboxmanage import openhpc-demo-client00.ova --options keepallmacs

vboxmanage import openhpc-demo-client01.ova --options keepallmacs 
```

``` bash
vboxmanage startvm openhpc-demo-client00

vboxmanage startvm openhpc-demo-client01
```

Uma vez criada a máquina, você pode entrar nela por meio do comando **vagrant ssh**: 

``` bash
vagrant ssh
``` 

### Aqui está uma visão de todos os softwares que instalamos e configuramos automaticamente via vagrant: 

Nagios - fornecerá métricas e análises básicas do cluster. 

Ganglia - fornecerá métricas e análises básicas do cluster. 

ClusterShell - usado para executar comandos em paralelo entre nós do cluster - muito útil para testar e avaliar a funcionalidade do cluster. 

Node Health Check (NHC) - executa uma verificação periódica em cada nó de computação para verificar se o nó está em boas condições de funcionamento. 

Identificação de arquivos para sincronização por xCAT - sincronização de arquivos base do host SMS para os nós de computação gerenciados. 
