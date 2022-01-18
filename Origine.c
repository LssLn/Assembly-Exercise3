int somma_numeri(char *st, int d)
{ int i,somma;
somma=0;
for(i=0;i<d;i++)
{if(st[i]<58)
somma++;
else return-1;
}
return somma}
main() {
char ST[16];
int i,cnt;
for(i=0;i<2;i++){
printf("Inserisci una stringa di numeri);
scanf("%s",ST);
cnt=somma_numeri(ST,strlen(ST));
printf(" Numero= %d \n",cnt);
}
}
