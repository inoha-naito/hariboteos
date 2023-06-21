MAKE = make -r
DEL = rm -f

default:
	$(MAKE) img

ipl10.bin: ipl10.nas Makefile
	nasm ipl10.nas -o ipl10.bin -l ipl10.lst

asmhead.bin: asmhead.nas Makefile
	nasm asmhead.nas -o asmhead.bin -l asmhead.lst

bootpack.hrb: bootpack.c hrb.ld Makefile
	i386-elf-gcc -nostdlib -T hrb.ld bootpack.c -o bootpack.hrb

haribote.sys: asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img: ipl10.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy -i haribote.img haribote.sys ::

img:
	$(MAKE) haribote.img

run:
	$(MAKE) img
	qemu-system-i386 -drive file=haribote.img,format=raw,if=floppy

clean:
	-$(DEL) *.bin
	-$(DEL) *.lst
	-$(DEL) *.sys
	-$(DEL) *.hrb

src_only:
	$(MAKE) clean
	-$(DEL) haribote.img
