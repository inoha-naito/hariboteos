MAKE = make -r
DEL = rm -f

default:
	$(MAKE) img

ipl.bin: ipl.nas Makefile
	nasm ipl.nas -o ipl.bin -l ipl.lst

haribote.img: ipl.bin Makefile
	mformat -f 1440 -C -B ipl.bin -i haribote.img ::

asm:
	$(MAKE) ipl.bin

img:
	$(MAKE) haribote.img

run:
	$(MAKE) img
	qemu-system-i386 -drive file=haribote.img,format=raw,if=floppy

clean:
	-$(DEL) ipl.bin
	-$(DEL) ipl.lst
	-$(DEL) tail.bin
	-$(DEL) tail.lst

src_only:
	$(MAKE) clean
	-$(DEL) haribote.img
