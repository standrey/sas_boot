[bits 32]

VIDEO_MEMORY_ADDRESS equ 0xb8000
WHITE_ON_BLACK equ 0x0f

print32:
    pusha
    mov edx, VIDEO_MEMORY_ADDRESS

print32_loop:
    mov al, [ebx] ; [ebx] is the address of our character

    cmp al, 0 ; check if end of string
    je print32_done

    mov ah, WHITE_ON_BLACK
    mov [edx], ax ; store character + attribute in video memory
    add ebx, 1 ; next char
    add edx, 2 ; next video memory position

    jmp print32_loop

print32_done:
    popa
    ret
