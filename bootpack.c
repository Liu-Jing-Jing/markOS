/** 告诉gcc编译器，函数在别的文件里*/
void io_hlt(void);

void HariMain(void)
{
	int i;		/** i是32位的整数*/
	char *ptr;  	/** 变量ptr用来存放BYTE的地址*/

	// 显卡显存的起始地址 0xa0000	
	// 显存大小64 KB
	for (i = 0xa0000; i <= 0xaffff; i++)
	{
		ptr = i;
		*ptr = 7;
	}
fin:
	io_hlt();	/** 汇编实现的函数*/
	goto fin;
}
