## Synopsis

Simple bootloader for x86, it only prints its own binary content (little endian) 
on text terminal using int 10h AH=e0 (teletype output)
it also calls int 15 to emulate system pause for delay betwen two messages. 
I think this is valid Quine or not ?

## Installation

Compile it using NASM assembler in plain binary
```
nasm -f bin bootloader.asm -o bootloader.bin
```
Make floppy disk img from binary file, for example using dd tool http://www.chrysocome.net/dd
```
dd if=bootloader.bin of=bootloader.img bs=512 conv=notrunc count=1 
```
    
Mount it on real floppy and insert it in floppy driver ( configure BIOS to boot from floppy disk)
today, however, many PCs don't have a floppy drive so you can use some virtual machine  ( x86 emulatorBochs for example)
  
