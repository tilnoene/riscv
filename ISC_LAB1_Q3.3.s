.include "../MACROSv21.s"

.data	# Área de dados
STR: 	.string "Digite um numero:"	# define a string de endereço STR (endereço do primeiro caractere)
PAR:	.string " eh par!"		# define a string de endereço PAR
IMPAR:	.string " eh impar!"		# define a string de endereço IMPAR
# MARIO BROS THEME
NUMMARIO: .word 7
NOTASMARIO: 64, 250, 64, 250, 64, 375, 60, 250, 64, 250, 67, 500, 55, 500
# SIMPSONS MAIN THEME
NUMSIMPSONS: .word 12
NOTASSIMPSONS: 48, 500, 52, 500, 54, 250, 57, 250, 55, 250, 52, 250, 48, 500, 45, 250, 42, 250, 42, 250, 42, 250, 43, 250

.text	# Área do programa
.text	# Área do programa
INPUTINT:
	li a7,104	# Armazena o valor 104 no registrador a7 (serviço para imprimir uma string no Bitmap Display)
	la a0, STR	# Armazena o endereço da string STR no registrador a0
	li a1,80	# Coordenada X
	li a2,100	# Coordenada Y
	li a3,0x0038	# Define a cor do texto para verde
	li a4,0		# Define o frame 0
	ecall		# Imprime a string STR no Bitmap Display
	# Lê um inteiro no KDMMIO
	li a7,105	# Armazena o valor 105 no registrador a7 (serviço para ler um inteiro no KDMMIO)
	ecall		# Lê e salva o inteiro inserido no registrador a0
	mv t3,a0	# Copia o valor de a0 para t3
	# Imprime esse inteiro na tela	
	li a7,101	# Armazena o valor 101 no registrador a7 (serviço para imprimir um inteiro no Bitmap Display)
	mv a0,t3	# Copia o valor de t3 para a0, o número que foi inserido e que será impresso
	li a1,220	# Coordenada X
	li a2,100	# Coordenada Y
	li a3,0x0038	# Define a cor do texto para verde
	li a4,0		# Define o frame 0
	ecall		# Imprime o inteiro no Bitmap Display

PRINTINT: # Imprime o inteiro inserido na linha seguinte no Bitmap Display
	li a7,101	# Armazena o valor 101 no registrador a7 (serviço para imprimir um inteiro no Bitmap Display)
	mv a0,t3	# Copia o valor de t3 para a0, o número que foi inserido e que será impresso
	li a1,100	# Coordenada X
	li a2,115	# Coordenada Y
	li a3,0x0038	# Define a cor do texto para verde
	li a4,0		# Define o frame 0
	ecall		# Imprime o inteiro no Bitmap Display

VERIFICAPARIDADE: # Verifica a paridade do numéro em questão
	li a1,140	# Altera a coordenada X da string PAR/IMPAR para a direita
	li t1,2		# # Armazena o valor imediato 2 no registrador temporário t1
	rem t2,t3,t1	# Armazena em t2 o resto da divisão de t3 (valor digitado pelo usuário) por t1 (2)
	beq t2,zero,Ehpar	# Compara os valores t2 e 0:
				# Se t2 for 0 o número digitado é par, então o endereço PC recebe o endereço Ehpar e faz o salto para o mesmo
				# Se for diferente de 0 o número digitado é ímpar, então PC = PC + 4 e continua a execução linear da instrução seguinte
				# O registrador do inteiro inserido foi modificado (com relação ao pirmeiro program)
	j Ehimpar	# Realiza um salto para o endereço Ehimpar (Jump) (pseudoinstrução)
			# O programa foi separado em várias subrotinas para cada caso (par ou ímpar)

Ehpar: 
	la a0,PAR	# Armazena o endereço da string PAR no registrador a0 e continua a execução linear
	li a7,104	# Armazena o valor 104 no registrador a7 (serviço para imprimir uma string no Bitmap Display)
	ecall		# Imprime a string PAR no Bitmap Display
	j PLAYMARIO		# Salta para a rotina que toca a música tema do Super Mario

Ehimpar:
	la a0,IMPAR	# Armazena o endereço da string IMPAR no registrador a0 
	li a7,104	# Armazena o valor 104 no registrador a7 (serviço para imprimir uma string no Bitmap Display)
	ecall		# Imprime a string IMPAR no Bitmap Display

# Toca a abertura dos Simpsons
PLAYSIMPSONS: 
	la s0,NUMSIMPSONS	# Define o endereço do número de notas
	lw s1,0(s0)		# Lê o número de notas
	la s0,NOTASSIMPSONS	# Define o endereço das notas
	li t0,0			# Zera o contador de notas
	li a2,95		# Define o instrumento
	li a3,127		# Define o volume

LOOP:	beq t0,s1, EXIT		# Contador chegou no final? Então vá para FIM
	lw a0,0(s0)		# Lê o valor da nota
	lw a1,4(s0)		# Lê a duracao da nota
	li a7,31		# Define a chamada de syscall
	ecall			# Toca a nota
	mv a0,a1		# Passa a duração da nota para a pausa
	li a7,32		# Define a chamada de syscal 
	ecall			# Realiza uma pausa de a0 ms
	addi s0,s0,8		# Incrementa para o endereço da próxima nota
	addi t0,t0,1		# Incrementa o contador de notas
	j LOOP			# Volta ao LOOP

# Toca a música tema do Super Mario
PLAYMARIO:
	la s0,NUMMARIO		# Define o endereço do número de notas
	lw s1,0(s0)		# Lê o número de notas
	la s0,NOTASMARIO	# Define o endereço das notas
	li t0,0			# Zera o contador de notas
	li a2,95		# Define o instrumento
	li a3,127		# Define o volume

LOOP2:	beq t0,s1, EXIT		# Contador chegou no final? Então vá para FIM
	lw a0,0(s0)		# Lê o valor da nota
	lw a1,4(s0)		# Lê a duracao da nota
	li a7,31		# Define a chamada de syscall
	ecall			# Toca a nota
	mv a0,a1		# Passa a duração da nota para a pausa
	li a7,32		# Define a chamada de syscal 
	ecall			# Realiza uma pausa de a0 ms
	addi s0,s0,8		# Incrementa para o endereço da próxima nota
	addi t0,t0,1		# Incrementa o contador de notas
	j LOOP2			# Volta ao LOOP2

EXIT:	li a7,10	# Armazena o valor imediato 10 no registrado a7 (serviço para encerrar o código - Exit)
	ecall		# Finaliza a execução do programa

.include "../SYSTEMv21.s"
