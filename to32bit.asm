[bits 16]
switch_to_32bit:
    cli ; disable interrupts
    lgdt [gdt_descriptor] ; load the GDT descriptor

    mov eax, cr0
    or eax, 0x1 ; set 32- bit mode bit in cr0
    mov cr0, eax

    jmp CODE_SEG:protected_mode ; far jump by using different segment

[bits 32]
protected_mode:
    mov al, 'A'
    mov ah, 0x0f
    mov [0xb8000], ax
    hlt
    ;call execute_kernel ; call a wel-known label with useful code

start_segment:
    dd 0x0
    dd 0x0

code_segment: 
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0

data_segment:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

end_segment:

gdt_descriptor:
    dw end_segment - start_segment - 1
    dd start_segment

CODE_SEG equ code_segment - start_segment
DATA_SEG equ data_segment - start_segment

 
