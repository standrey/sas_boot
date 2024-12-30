start_segment:
    dq 0x0

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


