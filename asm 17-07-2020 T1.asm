;# int somma_numeri(char *st, int d)
;# { int i,somma;
;# somma=0;
;# for(i=0;i<d;i++)
;# {if(st[i]<58)
;# somma++;
;# else return-1;
;# }
;# return somma}
;# main() {
;# char ST[16];
;# int i,cnt;
;# for(i=0;i<2;i++){
;# printf("Inserisci una stringa di numeri);
;# scanf("%s",ST);
;# cnt=somma_numeri(ST,strlen(ST));
;# printf(" Numero= %d \n",cnt);
;# }
;# }

.data 
ST: .space 16 ;# ST[16]
stack: .space 32

msg1: .asciiz "Inserisci str di soli numeri\n"
msg2: .asciiz "Numero= %d\n" ;# cnt 1°arg msg2

p1sys5: .space 8
cnt: .space 8 ;# 1° arg msg2

p1sys3: .word 0 ;#fd null
ind: .space 8
dim: .word 16 ;# numbyte da leggere <= ST

.code
;#init stack
daddi $sp,$0,stack
daddi $sp,$sp,32

daddi $s0,$0,0 ;# i=0
for: ;# for (i<2) 2 cicli
    slti $t0,$s0,2 ;# $t0=0 quando $s0(i) >= 2
    beq $t0,$0,exit ;# exit quando $t0 = 0

    ;#printf msg1
    daddi $t0,$0,msg1
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;# scanf %s ST
    daddi $t0,$0,ST
    sd $t0,ind($0)
    daddi r14,$0,p1sys3
    syscall 3
    ;# passaggio parametri : somma_numeri(ST,strlen)
    daddi $a0,$0,ST ;# $a0 = ST
    move $a1,r1 ;# $a1 = strlen
    jal somma_numeri
    sd r1,cnt($0) ;# cnt = return
    ;# printf msg2
    daddi $t0,$0,msg2
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;# incremento i e salto al for : ciclo
    daddi $s0,$s0,1 ;# i++
    j for
somma_numeri: ;# $a0 = ST, $a1 = strlen
    daddi $sp,$sp,-16 ;# 8x2, i e somma
    sd $s1,0($sp) ;# i
    sd $s2,8($sp) ;# somma
    daddi $s1,$0,0 ;# i=0
    daddi $s2,$0,0 ;# somma=0

for_f:  ;# i<strlen
    slt $t0,$s1,$a1 ;# $t0=0 quando $s1(i) >= $a1 (strlen)
    beq $t0,$0,return ;#quando $t0=0 , esco dal loop e return somma

    ;# if(st[i]<58)
    dadd $t0,$a0,$s1 ;# $t0 = & st [i] = $a0 (st) + $s1 (i)
    lbu $t1,0($t0)      ;# $t1 = st[i]
    slti $t0,$t1,57     ;# $t0 = 0 quando $t1 >= 58 (ci sono lettere)
    ;# 58 non calcola a errato
    beq $t0,$0,return_1    ;# esco dal loop, return -1 (non va bene non sono soli num)
    daddi $s2,$s2,1 ;# se <58 ($t0==1) allora faccio somma++ e j for_f
    ;# a somma++ segue i++, avvengono assieme (se non c'è if soddisfatto =somma++, si esce dal ciclo)
    daddi $s1,$s1,1 ;# i++
    j for_f 

return_1: ;# else, return -1
    daddi r1,$0,-1 ;# r1 = -1
    ld $s1,0($sp)
    ld $s2,8($sp)
    daddi $sp,$sp,-16
    jr $ra
return: ;# fine for, return somma
    move r1,$s2 ;# r1 = somma
    ld $s1,0($sp)
    ld $s2,8($sp)
    daddi $sp,$sp,-16
    jr $ra
exit:
    syscall 0

;#end
