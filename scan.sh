#! /bin/env bash

#-------------------------HEADER----------------------------------------------------|
# AUTOR             : Marlon Brendo <marlonbrendo2013@gmail.com>
# DATA-DE-CRIAÇÃO   : 2020-12-25
# PROGRAMA          : Port Scan
# VERSÃO            : 1.0.0
# LICENÇA           : MIT
# DESCRIÇÃO 	    : Um programa simples para verificar portas abertas no localhost
#                                       
# CHANGELOG :


#---------------------Variáveis-----------------------------------------------------|

host="127.0.0.1"
ports_file=/tmp/ports.txt
port=""
port_test_count="0"
port_test="2020"

#-----------------------------------------------------------------------------------|

#---------------------Funções-------------------------------------------------------|
#Tratamentos de alguns erros
function verificaPortas(){
	
	 [[ "$1" -lt "0" ]] || [[ "$1" -gt "65535" ]] || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ "$2" -lt "0" ]] \
	 || [[ "$2" -gt 65535 ]] \
	 && { printf %b "\033[0;31m[!] Portas inválidas,tente um valor entre 0-65535 \033[m \n" ; exit 1;} 
		
}

#---------------------Testes--------------------------------------------------------|

#Verificando se possui a ferramenta netcat para testes de socket
[[ !  $(type -P nc) ]] && \
{ echo "Instale o netcat para testes de sockets:\[apt install nc\]" ; exit 1 ;}

#Realiza uma abertura da porta 2020 á 2025 e verifica se possível estabelecer conexão em alguma
while [[ "$?" -ne "0" ]]
do

	kill -9 "$!" 2> /dev/null
      	
	nc -l "$port_test"& 
	2> /dev/null > /dev/tcp/${host}/${port_test} 
	
	if [[ "$?" -eq "1"  ]]  &&  [[ "$port_test_count" -eq "5" ]] 
	then
			
	 	 printf %b "\033[0;31m[!] Não foi possível estabelecer uma conexao com os sockets. \033[m\n" 
		 exit 1
	fi

	
	let port_test_count++
	let port_test++

done


#-----------------------------------------------------------------------------------|

printf "
	______          _                       
	| ___ \        | |                      
	| |_/ /__  _ __| |_ ___  ___ __ _ _ __  
	|  __/ _ \| '__| __/ __|/ __/ _' | '_ \ 
	| | | (_) | |  | |_\__ \ (_| (_| | | | |
	\_|  \___/|_|   \__|___/\___\__,_|_| |_|

"



read -p "Porta mínima: " port_min
read -p "Porta máxima: " port_max


verificaPortas "$port_min" "$port_max"

port=$port_min

#Percorre as respectivas portas e verifica quais respondem 
while [[ "$port" -le "$port_max" ]]
do
	2> /dev/null > /dev/tcp/${host}/${port} 
	if [[ "$?" -eq "0"  ]] 
	then 
	 	echo "A porta ${port} esta aberta" >> $ports_file 	
		printf %b "\033[0;32m [*] A porta ${port} esta aberta \033[m \n" 
			
 	fi
	
	let port++
done



