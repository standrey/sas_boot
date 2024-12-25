[bits 16]
; load 'dh' sectors from drive 'dl' into es:bx
load_exe_from_disk:
    pusha
    push dx

    mov ah, 0x02
    mov al, dh
    mov cl, 0x02
    mov ch, 0x00
    mov dh, 0x00

    int 0x13
    jc disk_error

    pop dx
    cmp al, dh
    jne sector_count_error
    popa
    ret

disk_error:
    mov bx, MSG_DISK_ERROR
    jmp disk_loop

sector_count_error:
    mov bx, MSG_SECTOR_ERROR
    jmp disk_loop

disk_loop:
    call print16
    call print16_nl
    jmp $
