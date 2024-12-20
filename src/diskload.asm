disk_load:
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
    jmp disk_loop

sector_count_error:
    jmp disk_loop

disk_loop:
    mov bx, MSG_ERROR
    call print16
    call print16_nl
    jmp $
