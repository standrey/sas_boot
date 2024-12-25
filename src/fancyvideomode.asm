[bits 16]

fancy_video_mode:
    pusha
    
    mov ah, 0x00 ; int 0x10/ ah 0x00 = set video mode 
    mov al, 0x03 ; 80x24 color text mode
    int 0x10

    mov ah, 0x0b ; color
    mov bh, 0x00 ; palette
    mov bl, 0x01 ; back
    int 0x10

    popa
    ret
