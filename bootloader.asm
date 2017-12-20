start:
mov si, 7F00h   ;; set stack pointer after our bootloader 
mov ax, 0h		
mov ds, ax	    ;; set DS to 0;
mov di, 7C00h  	;; set Data pointer to memory location where is our bootloader loaded 

.printMemoryValue:
mov al, 0          ;;  Using int15 to simulate pause for real time output, ax,ah,cx,dx dictate pause length 
mov ah, 86h			
mov cx, 0006H
mov dx, 8480H
int 15h
mov ah, 0Eh		;; Ah to 0eh setting for teletyoe output ( int 10h)
mov dx, [ds:di]		;; moving content of first memory location in dx (7c00h)
push dx				;; save dx in our stack
xor  cx, cx        ;; for (int i = 0;

;; for loop used to output 16 bit string (0 & 1)
.loopstart:
cmp  cx, 00010h     ;; i < 16;
je  .loopend    ;; break if i >= 16		
pop dx				
rol dx, 1			;; rotating left 1 bit so we can extract MSF bit with our mask. because we write on screen from right to left
push dx 			;; save our curent dx to stack
and dx, 0000000000000001   ;; mask   
add dx, 30h			;; adding (30h) for ASCII ( 0 or 1)
push cx				;; saving our counter in stack because cx is volotile register		
mov al, dl			;; moving low 8 bits from dx (dl) to our teletype output register Al for calling int 10h
int 10h			;; int 10h ( al = character to output if ah = 0eH, teletype )
pop cx
add cx, 1		;; i++
jmp .loopstart  
 
.loopend:
mov al, 000Ah   ;; new Row
int 10h
mov al, 000Dh 		;; carriage return
int 10h
add di, 2h			;; adding 2 to our di pointer ( because we are in 16bit mode)
cmp di, 7E00h		;; are we at the end of our bootloader (7c00h + 200h )?
je .hlt				;; if yes halt
jmp .printMemoryValue	;; print next memory location ( di is increased by 2 )
.hlt:
hlt				;; ende 


; Pad to 510 bytes (boot sector size minus 2) with 0s, and finish with the two-byte standard boot signature
times 510-($-$$) db 0 
dw 0xAA55	        ; => 0x55 0xAA (little endian byte order)
