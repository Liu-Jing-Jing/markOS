

/** 函数的声明.告诉gcc编译器，函数在别的文件里*/
void io_hlt(void);
void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);

/** 函数声明.代码写在源文件的也需要声明*/
void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);

void HariMain(void)
{
	int i;		/** i是32位的整数*/
    char *p = 0xa0000;  /** 变量ptr用来存放BYTE的地址*/
    
    init_palette() /** 初始化调色板*/
 
	// 显卡显存的起始地址 0xa0000	
	// 显存大小64 KB
	for (i = 0x0000; i <= 0xffff; i++)
	{
        p[i] = i&0x0f;
	}

	for ( ; ; )
	{
		io_hlt();	/** 汇编实现的函数,代码在naskfunc.nas里面*/
	}
}
	
void init_palette(void)
{
	static unsigned char table_rgb[16 * 3] = {
		0x00, 0x00, 0x00,	/*  0:黑色*/
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
	io_cli(); 					
	io_out8(0x03c8, start);
	for (i = start; i <= end; i++) 
	{
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3;
	}
	io_store_eflags(eflags);	
	return;
}
