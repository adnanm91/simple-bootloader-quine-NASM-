start:
	; Set up 4K stack after this bootloader
	; [Remember: Effective Address = Segment*16 + Offset]
    ; Put address of the null-terminated string to output into 'si'
	
           ; Halt the CPU (until the next external interrupt)
mov si, 7F00h
mov ax, 0h
mov ds, ax	 
mov di, 7C00h  
.printMemoryValue:
	mov al, 0
	mov ah, 86h
	mov cx, 0006H
	mov dx, 8480H
	int 15h
  mov ah, 0Eh
  mov dx, [ds:di]
  push dx
 
 xor  ecx, ecx        ;; for (int i = 0;
 .loopstart:
    cmp  cx, 00010h     ;; i < 16;
    je  .loopend    ;; break if i >= 16		
	pop dx
	rol dx, 1
	push dx
	
	and dx, 0000000000000001
	add dx, 30h
	
	push cx
	push dx
	mov al, dl
	int 10h
	pop dx
	pop cx
	add cx, 1
	sub dx, 30h	
	pop dx
	
	push dx
    jmp .loopstart   
  .loopend:
   mov al, 000Ah
   int 10h
   mov al, 000Dh
   int 10h
   add di, 2h
   cmp di, 7E00h
   je .hlt
   jmp .printMemoryValue
   .hlt:
		hlt
   
	
; Pad to 510 bytes (boot sector size minus 2) with 0s, and finish with the two-byte standard boot signature
times 510-($-$$) db 0 
dw 0xAA55	        ; => 0x55 0xAA (little endian byte order)