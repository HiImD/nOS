CC = i686-elf-gcc

BOOT = boot.c
KERNEL = kernel.c
LINKER = linker.ld

BOOT_OBJ = $(BOOT:%.c=%.o)
KERNEL_OBJ = $(KERNEL:%.c=%.o)
OUT = myos.bin

GRUB_CFG = grub.cfg
ISODIR = isodir
ISO_OUT = myos.iso

.PHONY: checkpath addpath kernel os verify iso kboot

#Kernel compile
${KERNEL_OBJ}: ${KERNEL} 
	${CC} -c ${KERNEL} -o ${KERNEL_OBJ} -std=gnu99 -ffreestanding -O2 -Wall -Wextra 

${OUT}: ${BOOT_OBJ} ${KERNEL_OBJ} ${LINKER}
	${CC} -T ${LINKER} -o ${OUT} -ffreestanding -O2 -nostdlib ${BOOT_OBJ} ${KERNEL_OBJ}

${ISO_OUT}: ${OUT} ${GRUB_CFG}
	mkdir -p ${ISODIR}/boot/grub
	cp ${OUT} ${ISODIR}/boot/${OUT}
	cp ${GRUB_CFG} ${ISODIR}/boot/grub/${GRUB_CFG}
	grub-mkrescue -o ${ISO_OUT} ${ISODIR} 


#Kiem tra path co bao gom cross-compiler
checkpath:
ifneq (,(findstring $(HOME)/opt/cross/bin,$(PATH)))
	@echo "Cross-compiler in path"
else
	@echo "Cross-compiler not in path"
endif 

#Them cross-compiler vao path
addpath:
	export PATH="$(HOME)/opt/cross/bin:$(PATH)"

kernel: ${KERNEL_OBJ}

os: ${OUT}

verify: ${OUT}
	@if grub-file --is-x86-multiboot ${OUT}; then \
		echo multiboot confirmed; \
	else \
		echo the file is not multiboot; \
	fi 

iso: ${ISO_OUT}

kboot: ${OUT}
	qemu-system-i386 -kernel ${OUT}

iboot: ${ISO_OUT}
	qemu-system-i386 -cdrom ${ISO_OUT}
 