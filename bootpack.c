/**
 0:黑色 1:亮红色 2:亮绿色 3:亮黄色 4:亮蓝色 5:亮紫色 6:浅蓝色 7:白色 8:亮灰色
 9:暗红色 10:暗绿色 11:暗黄色 12:暗青色 13:暗紫色 14:浅暗蓝 15:暗灰色
 */
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

struct BOOTINFO
{
	char cyls, leds, vmode, reserve;
	short scrnx, scrny;
	char *vram;
};

// #pragma mark - Main
void HariMain(void)
{
    // char *vram;
	// int xsize, ysize;
	struct BOOTINFO *binfo;
    binfo = (struct BOOTINFO *) 0x0ff0; // 特殊用法, 指向首地址
    extern char hankaku[4096];
    
    //    static char font_A[16] =
    //    {
    //		0x00, 0x18, 0x18, 0x18, 0x18, 0x24, 0x24, 0x24,
    //		0x24, 0x7e, 0x42, 0x42, 0x42, 0xe7, 0x00, 0x00
    //	};
    
    init_palette(); /* 初始化调色板*/
    initHomeScreen(binfo->vram, binfo->scrnx, binfo->scrny);
    // 开始标志
    drawASCII8String(binfo->vram, binfo->scrnx, CGPointMake(7, 4), COL8_000000, (unsigned char *)"Mark I");
    drawASCII8String(binfo->vram, binfo->scrnx, CGPointMake(6, 3), COL8_FF0000, (unsigned char *)"Mark I");

    // 显示 字符ABC 123
    drawASCII8String(binfo->vram, binfo->scrnx, CGPointMake(10, 30), COL8_FFFF00, (unsigned char *)"ABC 123");
    
    
    drawASCII8String(binfo->vram, binfo->scrnx, CGPointMake(11, 51), COL8_000000, (unsigned char *)"markOS is running !");
    drawASCII8String(binfo->vram, binfo->scrnx, CGPointMake(10, 50), COL8_FFFFFF, (unsigned char *)"markOS is running !");
    // 尾部添加笑脸图标
    putfont8(binfo->vram, binfo->scrnx, 167, 51, COL8_FFFFFF, hankaku+0x01*16);

    // 显示变量的值
    char s[40];
    sprintf(s, "var scrnx = %d", binfo->scrnx);
	drawASCII8String(binfo->vram, binfo->scrnx, CGPointMake(10, 67), COL8_FFFFFF, (unsigned char *)s);
    
    
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
    
    // 字符串的结束标志是\0
	for (; *s != 0x00; s++)
    {
        // 转换到对应的地址上 *16
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
    
    drawRectWith8BitColor(p, COL8_FFFFFF, CGRectMake(2, 19, 55, 0));
    drawRectWith8BitColor(p, COL8_FFFFFF, CGRectMake(2, 2, 0, 17));
    
    drawRectWith8BitColor(p, COL8_848484, CGRectMake(2, 2, 55, 0));
    drawRectWith8BitColor(p, COL8_848484, CGRectMake(57, 2, 0, 17));
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
