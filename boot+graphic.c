//
//  bootpack.c
//  markOS Demo
//
//  Created by Mark Lewis on 17-3-10.
//  Copyright (c) 2017年 MarkLewis. All rights reserved.
//  v 0.3.3

#include <stdio.h>

#define COL8_000000		0
#define COL8_FF0000		1
#define COL8_00FF00		2
#define COL8_FFFF00		3
#define COL8_0000FF		4
#define COL8_FF00FF		5
#define COL8_00FFFF		6
#define COL8_FFFFFF		7
#define COL8_C6C6C6		8
#define COL8_840000		9
#define COL8_008400		10
#define COL8_848400		11
#define COL8_000084		12
#define COL8_840084		13
#define COL8_008484		14
#define COL8_848484		15
/**
 0:黑色 1:亮红色 2:亮绿色 3:亮黄色 4:亮蓝色 5:亮紫色 6:浅蓝色 7:白色 8:亮灰色
 9:暗红色 10:暗绿色 11:暗黄色 12:暗青色 13:暗紫色 14:浅暗蓝 15:暗灰色
 */
#define kScreenXSize    320
#define kScreenYSize    200
/* ----------绘图功能区---------- */
#define CGFLOAT_TYPE float

typedef CGFLOAT_TYPE CGFloat;
/* Point*/
struct CGPoint {
    CGFloat x;
    CGFloat y;
};
typedef struct CGPoint CGPoint;
/* Sizes*/

struct CGSize {
    CGFloat width;
    CGFloat height;
};
typedef struct CGSize CGSize;

/* Rectangle */
struct CGRect {
    CGPoint origin;
    CGSize size;
};
typedef struct CGRect CGRect;



CGPoint CGPointMake(CGFloat x, CGFloat y);
CGSize CGSizeMake(CGFloat width, CGFloat height);
CGRect CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

CGPoint CGPointMake(CGFloat x, CGFloat y)
{
    CGPoint p; p.x = x; p.y = y; return p;
}

CGSize CGSizeMake(CGFloat width, CGFloat height)
{
    CGSize size; size.width = width; size.height = height; return size;
}

CGRect CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect = {CGPointMake(x, y), CGSizeMake(width, height)};
    return rect;
}

const CGPoint CGPointZero = {0, 0};
const CGSize CGSizeZero = {0, 0};
const CGRect CGRectZero = {{0, 0}, {0, 0}};
/* ----------绘图功能区---------- */


/** 函数的声明.告诉gcc编译器，函数在别的文件里*/
void io_hlt(void);
void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);

/** 函数声明.代码写在源文件的也需要声明*/
void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);
void drawRectWith8BitColor(unsigned char *vRAM, unsigned char color, CGRect rect);
void initHomeScreen(char *vram, int x, int y);
void putfont8(char *vram, int xsize, int x, int y, char color, char *font);
void drawASCII8String(char *vram, int xsize, CGPoint point, char color, unsigned char *s);
// void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1);
void init_mouse_cursor8(char *mouse, char bc);
void putblock8_8(char *vram, int vxsize, int pxsize, int pysize, int px0, int py0, char *buf, int bxsize);



struct SEGMENT_DESCRIPTOR
{
	short limit_low, base_low;
	char base_mid, access_right;
	char limit_high, base_high;
};

struct GATE_DESCRIPTOR
{
	short offset_low, selector;
	char dw_count, access_right;
	short offset_high;
};
void init_gdtidt(void);
void set_segmdesc(struct SEGMENT_DESCRIPTOR *sd, unsigned int limit, int base, int ar);
void set_gatedesc(struct GATE_DESCRIPTOR *gd, int offset, int selector, int ar);
void load_gdtr(int limit, int addr);
void load_idtr(int limit, int addr);
/* ----------GDT(全局分段记录表) IDT(interrupt) 初始化---------- */


struct BOOTINFO
{
	char cyls, leds, vmode, reserve;
	short scrnx, scrny;
	char *vram;
};

#pragma mark - Main
void HariMain(void)
{
    // char *vram;
	// int xsize, ysize;
	struct BOOTINFO *binfo;
    binfo = (struct BOOTINFO *) 0x0ff0; // 特殊用法, 指向首地址
	char mcursor[256];
	int mx, my;
    mx = (binfo->scrnx - 16) / 2; // 计算鼠标指针在屏幕中央的坐标位置
	my = (binfo->scrny - 28 - 16) / 2;

    
    // 初始化GDT和IDT
	init_gdtidt();
    init_palette(); /* 初始化调色板*/
    initHomeScreen(binfo->vram, binfo->scrnx, binfo->scrny);
    
    // 显示 字符ABC 123
    drawASCII8String(binfo->vram, binfo->scrnx, CGPointMake(10, 30), COL8_FFFF00, (unsigned char *)"ABC 123");
    drawASCII8String(binfo->vram, binfo->scrnx, CGPointMake(20, 36), COL8_FFFFFF, (unsigned char *)"markOS is running !");
    
    drawASCII8String(binfo->vram, binfo->scrnx, CGPointMake(21, 37), COL8_000000, (unsigned char *)"markOS is running !");
    
    char s[40];
    sprintf(s, "scrnx = %d", binfo->scrnx);
	drawASCII8String(binfo->vram, binfo->scrnx, CGPointMake(20, 64), COL8_FFFFFF, (unsigned char *)s);

    
    // mouse存放鼠标指针的颜色
    init_mouse_cursor8(mcursor, COL8_008484);
	putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);
	sprintf(s, "(%d, %d)", mx, my);
	// putfonts8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, s);
    drawASCII8String(binfo->vram, binfo->scrnx, CGPointMake(260, 5), COL8_FFFFFF, (unsigned char *)s);
    
    for ( ; ; )
	{
		io_hlt();	/** 汇编实现的函数,代码在naskfunc.nas里面*/
	}
}

void putfont8(char *vram, int xsize, int x, int y, char c, char *font)
{
	int i;
	char *p;
    char d /* data */;
	for (i = 0; i < 16; i++) {
		p = vram + (y + i) * xsize + x;
		d = font[i];
		if ((d & 0x80) != 0) { p[0] = c; }
		if ((d & 0x40) != 0) { p[1] = c; }
		if ((d & 0x20) != 0) { p[2] = c; }
		if ((d & 0x10) != 0) { p[3] = c; }
		if ((d & 0x08) != 0) { p[4] = c; }
		if ((d & 0x04) != 0) { p[5] = c; }
		if ((d & 0x02) != 0) { p[6] = c; }
		if ((d & 0x01) != 0) { p[7] = c; }
	}
	return;
    
}

void drawASCII8String(char *vram, int xsize, CGPoint point, char color, unsigned char *s)
{
	extern char hankaku[4096];
    
    int x = point.x;
    int y = point.y;
	for (; *s != 0x00; s++)
    {
		putfont8(vram, xsize, x, y, color, hankaku + *s * 16);
		x += 8;
	}
	return;
    
}

void initHomeScreen(char *vram, int x, int y)
{
    int maxScreenX = kScreenXSize -1;
    // int maxScreenY = kScreenYSize -1;
    
    int statusBarH = 21;
    unsigned char * p =  (unsigned char*)vram;
    // 画两个矩形
    drawRectWith8BitColor(p, COL8_C6C6C6, CGRectMake(0, 0, maxScreenX, statusBarH));
    drawRectWith8BitColor(p, COL8_008484, CGRectMake(0, statusBarH+1, maxScreenX, maxScreenX-statusBarH));
    
    // 画线
    drawRectWith8BitColor(p, COL8_FFFFFF, CGRectMake(0, statusBarH+1, maxScreenX, 0));
    
    drawRectWith8BitColor(p, COL8_FFFFFF, CGRectMake(2, 19, 59, 0));
    drawRectWith8BitColor(p, COL8_FFFFFF, CGRectMake(2, 2, 0, 17));
    
    drawRectWith8BitColor(p, COL8_848484, CGRectMake(2, 2, 59, 0));
    drawRectWith8BitColor(p, COL8_848484, CGRectMake(61, 2, 0, 17));
    /*
     boxfill8(COL8_000000,  2,         ysize -  3, 59,         ysize -  3);
     boxfill8(COL8_000000, 60,         ysize - 24, 60,         ysize -  3);
     
     boxfill8(COL8_848484, xsize - 47, ysize - 24, xsize -  4, ysize - 24);
     boxfill8(COL8_848484, xsize - 47, ysize - 23, xsize - 47, ysize -  4);
     boxfill8(COL8_FFFFFF, xsize - 47, ysize -  3, xsize -  4, ysize -  3);
     boxfill8(COL8_FFFFFF, xsize -  3, ysize - 24, xsize -  3, ysize -  3);
     */
}

void drawRectWith8BitColor(unsigned char *vRAM, unsigned char color, CGRect rect)
{
	int x, y;
    int x0 = rect.origin.x;
    int y0 = rect.origin.y;
    int x1 = x0+rect.size.width;
    int y1 = y0+rect.size.height;
    
	for(y= y0; y<=y1; y++)
	{
		for(x=x0; x<=x1; x++)
		{
			// 坐标转换为vRAM地址, 将颜色color填充到显存的这个地址
			vRAM[y*kScreenXSize + x] = color;
		}
	}
	return;
    
}


void init_palette(void)
{
	static unsigned char table_rgb[16 * 3] = {
		0x00, 0x00, 0x00,	/*  0:黑色*/
		0xff, 0x00, 0x00,	/*  1:亮红色*/
		0x00, 0xff, 0x00,	/*  2:亮绿色*/
		0xff, 0xff, 0x00,	/*  3:亮黄色*/
		0x00, 0x00, 0xff,	/*  4:亮蓝色*/
		0xff, 0x00, 0xff,	/*  5:亮紫色*/
		0x00, 0xff, 0xff,	/*  6:浅蓝色*/
		0xff, 0xff, 0xff,	/*  7:白色*/
		0xc6, 0xc6, 0xc6,	/*  8:亮灰色*/
		0x84, 0x00, 0x00,	/*  9:暗红色*/
		0x00, 0x84, 0x00,	/* 10:暗绿色*/
		0x84, 0x84, 0x00,	/* 11:暗黄色*/
		0x00, 0x00, 0x84,	/* 12:暗青色*/
		0x84, 0x00, 0x84,	/* 13:暗紫色*/
		0x00, 0x84, 0x84,	/* 14:浅暗蓝*/
		0x84, 0x84, 0x84	/* 15:暗灰色*/
	};
    
	set_palette(0, 15, table_rgb);
	return;
    
	/** 在C语言中static char只能用于数据。相当于汇编语言中的DB指令定义一比特数据*/
}


void set_palette(int start, int end, unsigned char *rgb)
{
	int i, eflags;
	eflags = io_load_eflags();			// 记录中断许可标志eflags的值
	io_cli(); 							// 将中断许可标志的值设为1 禁止中断
	io_out8(0x03c8, start);
	for (i = start; i <= end; i++)
	{
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3;
	}
	io_store_eflags(eflags);			// 复原中断许可的进位标志
	return;
}


/**
 *  初始化鼠标指针, 在显存中黑色和白色填充cursor的值
 *
 *  @param mouse 存放鼠标指针的背景颜色
 *  @param bc    鼠标背景色
 */
void init_mouse_cursor8(char *mouse, char bc)
{
	static char cursor[16][16] = {
		"**************..",
		"*OOOOOOOOOOO*...",
		"*OOOOOOOOOO*....",
		"*OOOOOOOOO*.....",
		"*OOOOOOOO*......",
		"*OOOOOOO*.......",
		"*OOOOOOO*.......",
		"*OOOOOOOO*......",
		"*OOOO**OOO*.....",
		"*OOO*..*OOO*....",
		"*OO*....*OOO*...",
		"*O*......*OOO*..",
		"**........*OOO*.",
		"*..........*OOO*",
		"............*OO*",
		".............***"
	};
    
	int x, y;
    
	for (y = 0; y < 16; y++)
    {
		for (x = 0; x < 16; x++)
        {
			if (cursor[y][x] == '*')
            {
				mouse[y * 16 + x] = COL8_000000;
			}
			if (cursor[y][x] == 'O')
            {
				mouse[y * 16 + x] = COL8_FFFFFF;
			}
			if (cursor[y][x] == '.')
            {
				mouse[y * 16 + x] = bc;
			}
		}
	}
	return;
}


/**
 *  填充鼠标指针的背景颜色
 *
 *  @param vram   显存的内存地址0xa0000开始
 *  @param vxsize 显示器的宽带320
 *  @param pxsize
 *  @param pysize
 *  @param px0
 *  @param py0
 *  @param buf
 *  @param bxsize
 */
void putblock8_8(char *vram, int vxsize, int pxsize, int pysize, int px0, int py0, char *buf, int bxsize)
{
	int x, y;
    
	for (y = 0; y < pysize; y++)
    {
		for (x = 0; x < pxsize; x++)
        {
			vram[(py0 + y) * vxsize + (px0 + x)] = buf[y * bxsize + x];
		}
	}
	return;
}



/**
    void  init_gdtidt()
    {
        struct GDT *gdt=(struct GDT *)(0x00270000);
        struct IDT *idt=(struct IDT *)(0x0026f800);
        int i;
        for(i=0;i<8192;i++)
        {
            setgdt(gdt+i,0,0,0);
        }
        setgdt(gdt+1,0xffffffff   ,0x00000000,0x4092);//entry.s main.c data 4GB空间的数据都能访问
        setgdt(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
        //setgdt(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB
        setgdt(gdt+3,0x000fffff   ,0x00000000,0x409a);//entry.S code
        load_gdtr(0xfff,0X00270000);//this is right
        
        for(i=0;i<256;i++)
        {
            setidt(idt+i,0,0,0);
        }
        
        for(i=0;i<256;i++)
        {
            //setidt(idt+i,(int)asm_inthandler21,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了
            
        }
        //setidt(idt+0x21,(int)asm_inthandler21-0x280000,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了
        
        load_idtr(0x7ff,0x0026f800);//this is right
        
        return;
        
    }
    
    //对内存写idt与写gdt都是没有问题的，现在只能改lgdt 与lidt这两个函数了
}
 */
void init_gdtidt(void)
{
	struct SEGMENT_DESCRIPTOR *gdt = (struct SEGMENT_DESCRIPTOR *) 0x00270000;
	struct GATE_DESCRIPTOR    *idt = (struct GATE_DESCRIPTOR    *) 0x0026f800;
	int i;
    
	// GDT初始化
    // 全局 分段记录表
	for (i = 0; i < 8192; i++)
    {
		set_segmdesc(gdt + i, 0, 0, 0);
	}
	set_segmdesc(gdt + 1, 0xffffffff, 0x00000000, 0x4092);
	set_segmdesc(gdt + 2, 0x0007ffff, 0x00280000, 0x409a);
	load_gdtr(0xffff, 0x00270000);
    
    
    // 中断记录表初始化
    // IDT 初始化
	for (i = 0; i < 256; i++)
    {
		set_gatedesc(idt + i, 0, 0, 0);
	}
	load_idtr(0x7ff, 0x0026f800);
    
	return;
}


/**
 *  设置GDT gd:      gate describe
 *  @param sd       selector describe
 *  @param limit    最高和最低位
 *  @param base
 *  @param ar
 */
void set_segmdesc(struct SEGMENT_DESCRIPTOR *sd, unsigned int limit, int base, int ar)
{
	if (limit > 0xfffff)
    {
		ar |= 0x8000; /* G_bit = 1 */
		limit /= 0x1000;
	}
	sd->limit_low    = limit & 0xffff;
	sd->base_low     = base & 0xffff;
	sd->base_mid     = (base >> 16) & 0xff;
	sd->access_right = ar & 0xff;
    // 天啊，访问权限是一个非常重要的量，错一点都不行的
    
    
    // 低４位是limt的高位，高４位是访问的权限设置。
	sd->limit_high   = ((limit >> 16) & 0x0f) | ((ar >> 8) & 0xf0);
	sd->base_high    = (base >> 24) & 0xff;
	return;
}


/**
 *  设置GDT 描述表
 *
 *  @param gd       gate describe
 *  @param offset   偏移
 *  @param selector selector describe
 *  @param ar
 */
void set_gatedesc(struct GATE_DESCRIPTOR *gd, int offset, int selector, int ar)
{
    // idt中有32位的offset address
	gd->offset_low   = offset & 0xffff;
    
    // 16位的selector决定了base address
	gd->selector     = selector;
	gd->dw_count     = (ar >> 8) & 0xff;
	gd->access_right = ar & 0xff;
	gd->offset_high  = (offset >> 16) & 0xffff;
	return;
}
