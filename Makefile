# $@ = target file
# $< = first dependency
# $^ = all dependencies

ARCH=x86_64

# detect all .o files based on their .c source
C_SOURCES = $(wildcard src/*.c)
C_HEADERS = $(wildcard include/*.h)
OBJ_FILES = ${C_SOURCES:.c=.o}
BIN_FILES = ./bin

CC ?= x86_64-elf-gcc
LD ?= x86_64-elf-ld

# First rule is the one executed when no parameters are fed to the Makefile
all: run

# Notice how dependencies are built as needed
$(BIN_FILES)/kernel.bin: ${OBJ_FILES}
	$(LD) -nostdlib -m elf_i386 -o $@.elf -Ttext=0xf100 $^ 
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel -j .rela -j .reloc  --target=efi-app-$(ARCH) -O binary $@.elf $@

$(BIN_FILES)/os-image.bin: $(BIN_FILES)/main.bin $(BIN_FILES)/kernel.bin
	cat $^ > $@

run: $(BIN_FILES)/os-image.bin
	qemu-system-i386 -fda $<

echo: $(BIN_FILES)/os-image.bin
	xxd $<

# only for debug
kernel.elf: ${OBJ_FILES}
	$(LD) -nostdlib -m elf_i386 -o $@ -Ttext=0xf100 $^

debug: os-image.bin kernel.elf
	qemu-system-i386 -s -S -fda $(BIN_FILES)os-image.bin -d guest_errors,int &
	i386-elf-gdb -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

%.o: ${C_SOURCES} ${C_HEADERS}
	$(CC) -nostartfiles -g -m32 -ffreestanding -fno-pie -fno-stack-protector -c $< -o $@ # -g for debugging

%.o: src/%.asm
	nasm $< -f elf -o $@

$(BIN_FILES)/%.bin: src/%.asm
	nasm $< -f bin -o $@

%.dis: %.bin
	ndisasm -b 32 $< > $@

clean:
	$(RM) *.o *.dis *.elf
	$(RM) src/*.o $(BIN_FILES)/*.bin $(BIN_FILES)/*.elf
