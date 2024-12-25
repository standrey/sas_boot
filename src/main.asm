[org 0x7c00]
[bits 16]
IMAGE_DESTINATION_OFFSET equ 0x1000 ; The same one we used when linking the kernel

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax

mov [BOOT_DRIVE], dl ; Remember that the BIOS sets us the boot drive in 'dl' on boot
mov bp, 0x9000
mov sp, bp

mov bx, MSG_16BIT_MODE
call print16
call print16_nl

call load_kernel ; read the kernel from disk
call switch_to_32bit ; disable interrupts, load GDT,  etc. Finally jumps to 'BEGIN_PM'
jmp $ ; Never executed

%include "src/print16bit.asm"
%include "src/print32bit.asm"
%include "src/diskload.asm"
%include "src/gdtsegment.asm"
%include "src/to32bit.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print16
    call print16_nl

    mov bx, IMAGE_DESTINATION_OFFSET
    mov dh, 20 ; Number of sectors N to read from the disk - N*512 bytes
    mov dl, [BOOT_DRIVE]
    call load_exe_from_disk
    
    mov bx, MSG_LOAD_KERNEL_DONE
    call print16
    call print16_nl
    
    ret

[bits 32]
BEGIN_32BIT:
    mov ebx, MSG_32BIT_MODE
    call print32
    call IMAGE_DESTINATION_OFFSET ; Give control to the kernel
    jmp $ ; Stay here when the kernel returns control to us (if ever)


[bits 16]
BOOT_DRIVE db 0 ; It is a good idea to store it in memory because 'dl' may get overwritten
MSG_16BIT_MODE db "Started in 16-bit Real Mode", 0
MSG_32BIT_MODE db "Landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory...", 0
MSG_LOAD_KERNEL_DONE db "Loading kernel into memory is done", 0
MSG_DISK_ERROR db "Disk error!", 0
MSG_SECTOR_ERROR db "Sector error!", 0

    ; padding
times 510 - ($-$$) db 0
dw 0xaa55
