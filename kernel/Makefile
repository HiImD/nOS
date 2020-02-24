#Hosy config
DEFAULT_HOST!=../default-host.sh
HOST?=DEFAULT_HOST
HOST_ARCH!=../target-triplet-to-arch.sh $(HOST)

CFLAGS?=-O2 -g #GCC Flags
CPPFLAGS?=
LDFLAGS?=
LIBS?=

DESTDIR?=
PREFIX?=/usr/local
EXEC_PREFIX?=$(PREFIX)
BOOTDIR?=$(EXEC_PREFIX)/boot
INCLUDEDIR?=$(PREFIX)/include

CFLAGS:=$(CFLAGS) -Wall -Wextra
CPPFLAGS:= $(CPPFLAGS) -D__is_kernel -Iinclude
LDFLAGS:=$(LDFLAGS)
LIBS:=$(LIBS) -nostdlib -lk -lgcc

ARCHDIR=arch/$(HOST_ARCH)

include $(ARCHDIR)/make.config

CFLAGS:=$(CFLAGS) $(KERNEL_ARCH_CFLAGS)
CPPFLAGS:=$(CPPFLAGS) $(KERNEL_ARCH_CPPFLAGS)
LDFLAGS:=$(LDFLAGS) $(KERNEL_ARCH_LDFLAGS)
LIBS:=$(LIBS) $(KERNEL_ARCH_LIBS)

KERNEL_OBJS=\
$(KERNEL_ARCH_OBJS) \
kernel/kernel.o \

OBJS=\
$(ARCHDIR)/crti.o \
$(ARCHDIR)/crtbegin.o \
$(KERNEL_OBJS) \
$(ARCHDIR)/crtend.o \
$(ARCHDIR)/crtn.o \

LINK_LIST=\
$(LDFLAGS) \
$(ARCHDIR)/crti.o \
$(ARCHDIR)/crtbegin.o \
$(KERNEL_OBJS) \
$(LIBS) \
$(ARCHDIR)/crtend.o \
$(ARCHDIR)/crtn.o \

.PHONY: all install install-headers install-kernel
.SUFFIXES: .o .c .s 

all: myos.kernel

myos.kernel: $(OBJS) $(ARCHDIR)/linker.ld
	$(CC) -T $(ARCHDIR)/linker.ld -o $@ $(CFLAGS) $(LINK_LIST)
	grub-file --is-x86-multiboot myos.kernel

$(ARCHDIR)/crtbegin.o $(ARCHDIR)/crtend.o:
	OBJ=$(shell $(CC) $(CFLAGS) $(LDFLAGS) -print-file-name=$(@F)) && cp "$$OBJ" $@

.c.o:
	$(CC) -MD -c $< -o $@ -std=gnu11 $(CFLAGS) $(CPPFLAGS)

.s.o:
	$(CC) -MD -c $< -o $@ $(CFLAGS) $(CPPFLAGS)

install-headers:
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -R --preserve=timestamps include/. $(DESTDIR)$(INCLUDEDIR)/.

install-kernel: myos.kernel
	mkdir -p $(DESTDIR)$(BOOTDIR)
	cp myos.kernel $(DESTDIR)$(BOOTDIR)

install: install-headers install-kernel

-include $(OBJS:.o=.d)


# .PHONY: checkpath addpath kernel os verify iso kboot

# #Boot compile
# ${BOOT_OBJ}: ${BOOT}
# 	${AS} ${BOOT} -o ${BOOT_OBJ}

# #Kernel compile
# ${KERNEL_OBJ}: ${KERNEL} 
# 	${CC} -c ${KERNEL} -o ${KERNEL_OBJ} -std=gnu99 -ffreestanding -O2 -Wall -Wextra 

# ${OUT}: ${BOOT_OBJ} ${KERNEL_OBJ} ${LINKER}
# 	${CC} -T ${LINKER} -o ${OUT} -ffreestanding -O2 -nostdlib ${BOOT_OBJ} ${KERNEL_OBJ}

# ${ISO_OUT}: ${OUT} ${GRUB_CFG}
# 	mkdir -p ${ISODIR}/boot/grub
# 	cp ${OUT} ${ISODIR}/boot/${OUT}
# 	cp ${GRUB_CFG} ${ISODIR}/boot/grub/${GRUB_CFG}
# 	grub-mkrescue -o ${ISO_OUT} ${ISODIR} 


# #Kiem tra path co bao gom cross-compiler
# checkpath:
# ifneq (,$(findstring $(HOME)/Workspace/OSDev/opt/cross/bin,$(PATH)))
# 	@echo "Cross-compiler in path"
# else
# 	@echo "Cross-compiler not in path"
# endif 

# #Them cross-compiler vao path
# addpath:
# 	export PATH="$(HOME)/Workspace/OSDev/opt/cross/bin:$(PATH)"

# kernel: ${KERNEL_OBJ}
# 	echo ${KERNEL_OBJ}

# os: ${OUT}

# verify: ${OUT}
# 	@if grub-file --is-x86-multiboot ${OUT}; then \
# 		echo multiboot confirmed; \
# 	else \
# 		echo the file is not multiboot; \
# 	fi 

# iso: ${ISO_OUT}

# kboot: ${OUT}
# 	qemu-system-i386 -kernel ${OUT}

# iboot: ${ISO_OUT}
# 	qemu-system-i386 -cdrom ${ISO_OUT}
 
