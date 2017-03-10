/** 告诉gcc编译器，函数在别的文件里*/
void io_hlt(void);

void HariMain(void)
{
	int i;		/** i是32位的整数*/
    char *ptr = 0xa0000;  /** 变量ptr用来存放BYTE的地址*/
    
    
	for (i = 0x0000; i <= 0xffff; i++)
	{
        ptr[i] = i&0x0f;
	}

	for ( ; ; )
	{
		io_hlt();	/** 汇编实现的函数,代码在naskfunc.nas里面*/
	}
	
}
