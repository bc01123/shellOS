COMPILER = gcc
LINKER = ld
ASSEMBLER = nasm
CFLAGS = -m32 -c -ffreestanding
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T src/link.ld
EMULATOR = qemu-system-i386
EMULATOR_FLAGS = -kernel

OBJS = src/O/kasm.o src/O/kc.o src/O/idt.o src/O/isr.o src/O/kb.o src/O/screen.o src/O/string.o src/O/system.o src/O/util.o src/O/shell.o src/O/gui.o src/O/wall1.o src/O/csh.o src/O/shutdownPWM.o src/O/shutdownPWMtrigger.o
OUTPUT = shellOS/boot/kernel.bin

run: all
	$(EMULATOR) $(EMULATOR_FLAGS) $(OUTPUT)

all:$(OBJS)
	mkdir shellOS/ -p
	mkdir shellOS/boot/ -p
	$(LINKER) $(LDFLAGS) -o $(OUTPUT) $(OBJS)

src/O/kasm.o:src/KERNEL/kernel.asm
	$(ASSEMBLER) $(ASFLAGS) -o src/O/kasm.o src/KERNEL/kernel.asm
	
src/O/kc.o:src/KERNEL/kernel.c
	$(COMPILER) $(CFLAGS) src/KERNEL/kernel.c -o src/O/kc.o 
	
src/O/idt.o:src/SYSTEM/idt.c
	$(COMPILER) $(CFLAGS) src/SYSTEM/idt.c -o src/O/idt.o 

src/O/kb.o:src/SYSTEM/kb.c
	$(COMPILER) $(CFLAGS) src/SYSTEM/kb.c -o src/O/kb.o

src/O/isr.o:src/SYSTEM/isr.c
	$(COMPILER) $(CFLAGS) src/SYSTEM/isr.c -o src/O/isr.o

src/O/screen.o:src/SYSTEM/screen.c
	$(COMPILER) $(CFLAGS) src/SYSTEM/screen.c -o src/O/screen.o

src/O/string.o:src/SYSTEM/string.c
	$(COMPILER) $(CFLAGS) src/SYSTEM/string.c -o src/O/string.o

src/O/system.o:src/SYSTEM/system.c
	$(COMPILER) $(CFLAGS) src/SYSTEM/system.c -o src/O/system.o

src/O/util.o:src/SYSTEM/util.c
	$(COMPILER) $(CFLAGS) src/SYSTEM/util.c -o src/O/util.o
	
src/O/shell.o:src/UI/shell.c
	$(COMPILER) $(CFLAGS) src/UI/shell.c -o src/O/shell.o

src/O/gui.o:src/UI/gui.c
	$(COMPILER) $(CFLAGS) src/UI/gui.c -o src/O/gui.o

src/O/wall1.o:src/UI/wall1.c
	$(COMPILER) $(CFLAGS) src/UI/wall1.c -o src/O/wall1.o

src/O/csh.o:src/CONSOLE/csh.c
	$(COMPILER) $(CFLAGS) src/CONSOLE/csh.c -o src/O/csh.o

src/O/shutdownPWM.o:src/MGMT/shutdownPWM.asm
	$(ASSEMBLER) $(ASFLAGS) -o src/O/shutdownPWM.o src/MGMT/shutdownPWM.asm

src/O/shutdownPWMtrigger.o:src/MGMT/shutdownPWMtrigger.c
	$(COMPILER) $(CFLAGS) src/MGMT/shutdownPWMtrigger.c -o src/O/shutdownPWMtrigger.o

build:all
	#Activate the install xorr if you do not have it already installed
	#sudo apt-get install xorriso
	rm shellOS/boot/grub/ -r -f
	mkdir shellOS/boot/grub/
	echo set default=8 >> shellOS/boot/grub/grub.cfg
	echo set timeout=8 >> shellOS/boot/grub/grub.cfg
	echo menuentry "shellOS 1.5 - Terreza" { >> shellOS/boot/grub/grub.cfg
	echo         set root='(hd96)' >> shellOS/boot/grub/grub.cfg
	echo         multiboot /boot/kernel.bin >> shellOS/boot/grub/grub.cfg
	echo } >> shellOS/boot/grub/grub.cfg

	grub-mkrescue -o shellOS1-5.iso shellOS/
	
clear:
	rm -f obj/*.o
	rm -r -f iknow/
	
