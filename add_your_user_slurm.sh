#!/bin/bash
#criado por Licia e Tiago 24/11/2023

# Verifica se um nome foi fornecido
if [ -z "$1" ]; then
    echo "Por favor, forneça o seu belo nome como um argumento, nao tenho como saber seu nome se vc nao me contar <3."
    exit 1
fi

# Nome do aluno
ALUNO=$1

# Gerar um anagrama do nome do aluno
ANAGRAMA=$(echo $ALUNO | fold -w1 | shuf | tr -d '\n')

# Adicionar números aleatórios à senha
NUMEROS=$(shuf -i 100-999 -n 1)
SENHA="${ANAGRAMA}${NUMEROS}"

# Criar o usuário
useradd $ALUNO

# Definir a senha do usuário
echo -e "$SENHA\n$SENHA" | sudo passwd $ALUNO

# Adiciona comandos para registrar ações de sincronização
echo "MERGE:" > syncusers
echo "/etc/passwd -> /etc/passwd" >> syncusers
echo "/etc/group -> /etc/group" >> syncusers
echo "/etc/shadow -> /etc/shadow" >> syncusers

echo "Arquivo 'syncusers' criado com informações de sincronização."

echo "Usuário '$ALUNO' criado com sucesso. Senha: $SENHA"
echo $SENHA > /home/$ALUNO/${ALUNO}_senha.txt
echo ""
echo "Aguarde estamos sincronizando seu belo nome nas maquinas computes......"
xdcp compute -F syncusers
echo ""
echo "Teste seu usuário se quiser, com os comandos abaixo:


su - $ALUNO 
mpicc -O3 /opt/ohpc/pub/examples/mpi/hello.c
srun -n 4 -N 2 --pty /bin/bash
prun ./a.out
"
