[bits 16]
switch_to_32bit:
    mov bx, SWITCHING_TO_32
    call print16
    call print16_nl
   
    cli ; disable interrupts
    lgdt [gdt_descriptor] ; load the GDT descriptor
    mov eax, cr0
    or eax, 0x1 ; set 32- bit mode bit in cr0
    mov cr0,eax
    jmp CODE_SEG:init_32bit ; far jump by using different segment

[bits 32]
init_32bit:
    mov eax, DATA_SEG ; update segment registers
    mov ds, eax
    mov ss, eax
    mov es, eax
    mov fs, eax
    mov gs, eax

    mov ebp, 0x90000 ; update the stack right at the top of free space
    mov esp, ebp

    call BEGIN_32BIT ; call a wel-known label with useful code
