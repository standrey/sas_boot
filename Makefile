# $@ = target file
# $< = first dependency
# $^ = all dependencies

ARCH=i386

# detect all .o files based on their .c source
C_SOURCES = $(wildcard *.c)
OBJ_FILES = ${C_SOURCES:.c=.o}

CC ?= x86_64-elf-gcc
LD ?= x86_64-elf-ld

.PHONY: clean all 

# First rule is the one executed when no parameters are fed to the Makefile
all: run

# Notice how dependencies are built as needed
kernel.bin: ${OBJ_FILES}
	$(LD) -nostdlib -m elf_i386 -o $@.elf -Ttext=0x1000 $^
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel -j .rela -j .reloc  --target=efi-app-$(ARCH) -O binary $@.elf $@

os-image.bin: main.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 -fda $<

echo: os-image.bin
	xxd $<

debug: os-image.bin kernel.bin.elf
	qemu-system-i386 -fda os-image.bin -s -S -d guest_errors,int &
	gdb --nx -ex "set architecture i8086" -ex "target remote localhost:1234" -ex "symbol-file kernel.bin.elf" -ex "hbreak *0x7c00" -ex "continue"

%.o: ${C_SOURCES} 
	$(CC) -march=i686 -nostartfiles -g -m32 -ffreestanding -fno-pie -fno-stack-protector -c $< -o $@ # -g for debugging

%.o: %.asm
	nasm $< -g -f elf32 -o $@

%.bin: %.asm
	nasm $< -g -f bin -o $@

%.dis: %.bin
	ndisasm -b 32 $< > $@

clean:
	$(RM) *.o *.dis *.elf *.bin
	
