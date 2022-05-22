data segment    
    
    
    ;-------------- Segment de donnee associe a l'affichage de l'introduction-------------------------------
  
affiche db 10,13, "**************************************************************** "
        db 10,13, "*                                                              * "
        db 10,13, "*               _                                              * "
        db 10,13, "*              |_|                                             * "
        db 10,13, "*             /_/                                              * "
        db 10,13, "*     ___  ___ _    ECOLE nationale Superieure d'Informatique  * "
        db 10,13, "*    / _ \/ __| |   Cycle Preparatoire integre (CPI) - SYS2    * "
        db 10,13, "*   |  __/\__ \ |                                              * "
        db 10,13, "*    \___||___/_|                                              * "
        db 10,13, "*                                                              * "
        db 10,13, "*                                                              * "
        db 10,13, "*                                                              * "
        db 10,13, "*                                                              * "
        db 10,13, "*                                                              * "
        db 10,13, "* Section: B - Groupe: 11  - 2018/2019                         * "
        db 10,13, "*                                                              * "
        db 10,13, "*                                                              * "
        db 10,13, "**************************************************************** ",10,13,10,13
        db  "              APPUYER SUR UNE TOUCHE POUR COMMENCER                       ",10,13,10,13 ,'$' 
        
        
        
        
        intro db 10,13," ******************************************************************************"
      db 10,13," *                                                                            *"
      db 10,13," *                TP ASSEMBLEUR - Convertisseur ARABE <===> ROMAIN            *"
      db 10,13," *                                                                            *" 
      db 10,13," ******************************************************************************" ,'$'
    ;----------------------- Segment de donnee associe a l'affichage du menu ------------------------      
        
      
menu  db 10,13,10,13," Veuillez faire un choix dans le menu suivant :  " 
      db 10,13," "
      db 10,13,"  1) Conversion ARABE -> ROMAIN " 
      db 10,13,"  2) Conversion ROMAIN -> ARABE "
      db 10,13,"  3) Quitter " 
      db 10,13,'$'
      
      
choix:  db 10,13,"     Votre Choix :  $"   
err_choix db 10,13,"/!\ ERREUR - Le choix doit etre compris entre 1 et 3 .",10,13,'$'
                                                     
      ;------------------ Segment de donnee associe a la conversion arabe --> romain -------------------         
 
            beg dw ? 
      fin dw ?   
      d dw ?  
          
  romain Dw "I ","V","X","L","C","D","M" 
    arabe  DW  1,5,10,50,100,500,1000
    decimal DW ?   
   
    nbr_arabe DB 8 DUP(?)        
     msg DB '   Entrez un chiffre arabe : ','$'    
     msg_sl db 13,10,'$'
     msg_er1 DB ' vous avez entre une valeur negative' ,'$'
     msg_er2 DB ' vous avez entre une valeur nulle '   ,'$'
     msg_er3 DB ' vous avez entre une valeur superieure a 4999' ,'$'       
     msg_er4 db ' veuillez entre un nombre reel','$' 
     msg_ecr db 'la valeur en chiffre romain  est : ','$'  
     msg_er5 db 'le nombre romain est invalide ','$'
 
     ;------------------ Segment de donnee associe a la conversion romain --> arabe ----------------------
     quit db 10,13, "press any key$"
msg1 db 10,13, "Entrez un chiffre romain en maj : $" 
msg2 db 10,13, "le chiffre romain en en arabe :  $" 
saut db 13,10,'$'
romain1 dw 'M','D','C','L','X','V','I'
arabe1 dw 1000d,500d,100d,50d,10d,5d,1d
nbr dw 20 dup ('$')
j1 dw ?
j2 dw ?
nba dw 0
 
ends  
code segment   
     include 'emu8086.inc'    
                        
                        define_print_num_uns
   
  
    Introd PROC
     
_affiche:   

      MOV DX,offset affiche
      MOV AH,9
      INT 21H 


_menu:   

      MOV DX,offset menu
      MOV AH,9
      INT 21H 

_choix:      
         
      MOV DX,offset choix
      MOV AH,9
      INT 21H        
        
         
      MOV AH,1
      INT 21H


      CMP AL,32h
      JE  ROM_ARB
       
      
      CMP AL,33h
      JE exit
      
      CMP AL,31h
      JE ARB_ROM


      MOV DX,offset err_choix
      MOV AH,9
      INT 21H 

      JMP _choix 

  
  
      RET 
      
   ARB_ROM PROC 
   
 
   
       
          

     
           MOV DX,offset msg
    MOV AH,9
    INT 21H 
        
         CALL SCAN_NUM         
    MOV decimal,cx  
    mov bx,cx   
   
    
  mov dx,0000  
   CMP cX,dx
      Jl INVALID2 
      jmp begin
      
        
      
      ;comparaison du nombre avec 0000
      
         INVALID2 :
      MOV cX,offset msg_er2
      MOV AH,9
      INT 21H 
      jmp begin  
      
    
      
      
      
      
      
 begin:  
    
    MOV DI,0
    
             MOV DX,offset msg_sl
      MOV AH,9
      INT 21H
      

     mov beg,0
     mov fin,0 
      MOV DX,offset msg_ecr
      MOV AH,9
      INT 21H
     
                mov ax,decimal
   tq: cmp ax,0 
   jle  ftq     
   
   
       mov beg,12 
       mov cx,6  
       mov ax,decimal   
       mov si,beg
       mov di,fin 
       jmp pour1
       ftq:
       jmp _menu
          
     pour1:   
     mov cx,arabe[si]
     cmp ax,arabe[si]     
     
        jge FSI 
        sub si,2
           
        mov beg,si
        loop   pour1
        jmp FSI
        
         FSI:
         
             mov cx,6
            mov di,0 
     pour2:
     mov bx,decimal
     mov dx,arabe[di]    
     cmp bx,arabe[di]
        jle FSI1
        add di,2
        mov fin,di 
       
        loop   pour2  
        jmp FSI1        
        FSI1:
        mov ax,decimal 
         
        cwd  
        mov d,ax
        
      tq1:   cmp ax,0  
         je ftq1
         mov bx,10
         div bx
         mov d,ax
         cwd 
              
          cmp ax,10
          jl ftq1 
          jmp tq1
          ftq1:jmp suite 
           
  suite:  
  mov si,beg
  mov di,fin  
  mov ax,decimal 
  cmp ax,10
  jb    verrif
  jmp sinon1
  verrif: cmp ax,4
  je alors
      jmp sinon1
  alors: 
         mov si,beg
  mov ax,romain[si] 
  mov dl,al 
  mov ah,2
  int 21h
                   mov di,fin 
  mov ax,romain[di]
  mov dl,al 
  mov ah,2
  int 21h
  mov ax,0
  mov decimal,ax
  jmp tq  
  sinon1: 
  mov ax,decimal 
  cmp ax,10
  jg verrif2 
  jmp sinon2
  verrif2:
  mov ax,d
  cmp ax,4
  je verrif3
  jmp sinon2
  verrif3:
   mov si,beg
  mov ax,si
  cmp ax,12
  jl alors1
  jmp sinon2
  alors1:  
   mov si,beg
  mov ax,romain[si]
  mov dl,al 
  mov ah,2
  int 21h
  mov ax,romain[di] 
  mov dl,al 
  mov ah,2
  int 21h
  mov ax,decimal 
   mov di,fin 
  mov bx,arabe[di] 
   mov si,beg
  sub bx,arabe[si]
  sub ax,bx  
  mov decimal,ax 
  jmp tq
  sinon2:   
  mov ax,decimal 
  cmp ax,10
  jg verrif4 
  jmp sinon3
  verrif4:
  mov ax,d
  cmp ax,4
  je verrif5
  jmp sinon3
  verrif5:
   mov si,beg
  mov ax,si
  cmp ax,12
  je alors2
  jmp sinon3
  alors2:  
   mov si,beg
  mov ax,romain[si] 
  mov dl,al 
  mov ah,2
  int 21h
  mov ax,decimal 
   mov si,beg
  sub ax,arabe[si]
  mov decimal,ax
  jmp tq  
  sinon3:
  mov ax,decimal
  cmp ax,10
  jb verrif6
  jmp sinon4
  verrif6:
  cmp ax,9 
  je alors3
  jmp sinon4
  alors3:      
   mov si,beg
  mov ax,romain[si-2] 
 mov dl,al 
  mov ah,2
  int 21h 
   mov di,fin 
  mov ax,romain[di]
  mov dl,al 
  mov ah,2
  int 21h
  mov ax,0
  mov decimal,ax 
  jmp tq
  sinon4:
  mov ax,decimal
  cmp ax,10
  jg verrif7
  jmp sinon5
  verrif7:
  mov ax,d
  cmp ax,9
  je alors4
  jmp sinon5     
   mov si,beg
  alors4:mov ax,romain[si-2] 
 mov dl,al 
  mov ah,2
  int 21h  
   mov di,fin 
  mov ax,romain[di]
 mov dl,al 
  mov ah,2
  int 21h     
   mov di,fin 
  mov bx,arabe[di]    
   mov si,beg 
   mov dx,arabe[si-2]
  sub bx,dx
  mov ax,decimal
  sub ax,bx
  mov decimal,ax 
  jmp tq
  sinon5:
   mov si,beg
  mov ax,romain[si] 
  mov dl,al 
  mov ah,2
  int 21h
  mov ax,decimal 
   mov si,beg
  sub ax,arabe[si] 
  mov decimal,ax
   jmp tq
   
   
       
       
   ARB_ROM ENDP   
   ROM_ARB proc
    
        lecture1  proc    
           
        lea dx,msg1 
        mov ah,9h
        int 21h
        mov si,offset nbr
        l1:
        mov ah,1
        int 21h
        cmp al,13d
        je done
        mov [si],al
        inc si 
        inc si
        jmp l1   
        done:        
        jmp suite_2
           
           
       
       lecture1 endp
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start:

mov ax,data
mov ds,ax
mov es,ax
;code   
call lecture1  
suite_2:

         




 
mov si,0  

;boucle tq1 
tq_1: 
cmp nbr[si],'$'   
je ftq_1
;action tq1
mov j1,0
mov j2,0 

;boucle if
cmp nbr[si+2],'$'
jne sinon_1
;action si1 
mov di,0
;boucle tq2
 tq_2:
 mov  ax,romain1[di]
 cmp ax,nbr[si]
 je ftq_2 
;action tq2
 add di,2
 jmp tq_2
 ftq_2:
 
 ;fin boucle tq2
   
  mov ax,arabe1[di]
  ;cbw 
  add nba,ax
 add si,2
 
jmp fsi_1
sinon_1:
;action sinon1 


;boucle tq3

tq_3: 
mov ax,j1 
 
mov bx,ax
mov ax,romain1[bx]
cmp nbr[si],ax
je ftq_3

;action tq3
add j1,2

jmp tq_3
ftq_3:

  jmp tq_4

;boucle tq4

tq_4:
mov ax,j2
 
mov bx,ax
mov ax,romain1[bx]
cmp nbr[si+2],ax

je ftq_4
add j2,2
jmp tq_4
ftq_4:

 

;boucle si2
;calcul cond
mov ax,j2
 
mov bx,ax
mov cx,arabe1[bx] 

mov ax,j1

mov bx,ax
   
cmp arabe1[bx],cx
jl sinon_2
;ation si2 
 
mov ax,j1

mov bx,ax
mov ax,arabe1[bx]
add nba,ax
add si,2
jmp fsi_2
sinon_2: 
;ation sinon2
mov ax,j2

mov bx,ax
mov ax,arabe1[bx]
add nba,ax


mov ax,j1
 
mov bx,ax
mov ax,arabe1[bx]
sub nba,ax
add si,4

fsi_2:

  jmp fsi_1
 
 
 
 
 
fsi_1:

;fin tq1
jmp tq_1
ftq_1:  


     lea dx,msg2 

  mov ah,9h
        int 21h
        
 
 mov ax,nba 
 call PRINT_NUM_UNS    
 jmp _menu
   
   		

         
                
                
  
                
      
DEBUT:
          
      MOV AX, data
      MOV DS, AX     
                     
      CALL Introd 
             
exit: MOV AH,4ch
      INT 21h 
       DEFINE_scan_NUM  
       
code ENDS
      END DEBUT