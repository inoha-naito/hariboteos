OBJS_BOOTPACK = bootpack.o graphic.o dsctbl.o naskfunc.o hankaku.o mysprintf.o

MAKE = make -r
DEL = rm -f

CC = i386-elf-gcc

default:
	$(MAKE) img

convHankakuTxt: convHankakuTxt.c
	gcc $< -o $@

hankaku.c: hankaku.txt convHankakuTxt
	./convHankakuTxt

ipl10.bin: ipl10.nas
	nasm $< -o $@ -l ipl10.lst

asmhead.bin: asmhead.nas
	nasm $< -o $@ -l asmhead.lst

naskfunc.o: naskfunc.nas
	nasm -f elf $< -o $@ -l naskfunc.lst

bootpack.hrb: hrb.ld $(OBJS_BOOTPACK)
	$(CC) -nostdlib -T $< $(OBJS_BOOTPACK) -o $@

haribote.sys: asmhead.bin bootpack.hrb
	cat $^ > $@

haribote.img: ipl10.bin haribote.sys
	mformat -f 1440 -C -B $< -i $@ ::
	mcopy -i $@ haribote.sys ::

%.o: %.c
	$(CC) -fno-builtin -c $*.c -o $*.o

img:
	$(MAKE) haribote.img

run:
	$(MAKE) img
	qemu-system-i386 -drive file=haribote.img,format=raw,if=floppy

clean:
	-$(DEL) *.bin
	-$(DEL) *.lst
	-$(DEL) *.o
	-$(DEL) *.sys
	-$(DEL) *.hrb
	-$(DEL) hankaku.c
	-$(DEL) convHankakuTxt

src_only:
	$(MAKE) clean
	-$(DEL) haribote.img
