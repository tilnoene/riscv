.data	# Área de dados
STR: 	.string "Digite um numero:"	# define a string de endereço STR (endereço do primeiro caractere)
PAR:	.string " eh par!"		# define a string de endereço PAR
IMPAR:	.string " eh impar!"		# define a string de endereço IMPAR

.text	# Área do programa
	la a0,STR	# Armazena o endereço (do início) da string STR no registrador a0
	li a7,4		# Armazena o valor imediato 4 no registrador a7 (serviço para imprimir uma string no console - PrintString)
	ecall		# Imprime a string STR no console (PrintString) - chamada de sistema
	li a7,5		# Armazena o valor imediato 5 no registrador a7 (serviço para ler um inteiro do console - ReadInt)
	ecall		# Lê o inteiro digitado no console (ReadInt)
	li a7,1		# Armazena o valor imediato 1 no registrador a7 (serviço para imprimir um inteiro no console - PrintInt)
	ecall		# Imprime o valor digitado anteriormente no console (PrintInt)
	li t1,2		# Armazena o valor imediato 2 no registrador temporário t1
	rem t2,a0,t1	# Armazena em t2 o resto da divisão de a0 (valor digitado pelo usuário) por t1 (2)
	beq t2,zero,Ehpar	# Compara os valores t2 e 0:
				# se t2 for 0 o número digitado é par, então o endereço PC recebe o endereço Ehpar e faz o salto para o mesmo
				# se for diferente de 0 o número digitado é ímpar, então PC = PC + 4 e continua a execução linear da instrução seguinte
	la a0,IMPAR	# Armazena o endereço da string IMPAR no registrador a0
	j Mostra	# Realiza um salto para o endereço Mostra (Jump) (pseudoinstrução), PC = Mostra
Ehpar: la a0,PAR	# Armazena o endereço da string PAR no registrador a0 e continua a execução linear
Mostra: li a7,4		# Armazena o valor imediato 4 no registrador a7 (serviço para imprimir uma string no console - PrintString)
	ecall		# Imprime a string cujo endereço está em a0 (PAR ou IMPAR) no console (PrintString)
	li a7,10	# Armazena o valor imediato 10 no registrado a7 (serviço para encerrar o código - Exit)
	ecall		# Finaliza a execução do programa
