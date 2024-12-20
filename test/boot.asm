org 0x7c00
bits 16

start:
    cli
    mov si, msg
    mov ah, 0x0E

.loop lodsb
    or al, al
    jz halt
    int 0x10
    jmp .loop

halt: hlt
msg: db "Hello, Playrix!", 0

times 510 - ($ - $$) db 0x00
dw 0xAA55
