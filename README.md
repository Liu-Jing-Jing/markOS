# markOS
- Version: beta 0.0.7 将磁盘的启动扇区和C0-H0-S2读入内存中
- [学习笔记更新](https://github.com/Liu-Jing-Jing/markOS/wiki)

```
[代码块](https://github.com/Liu-Jing-Jing/markOS/blob/master/helloOS.asm)
entry:

MOV		AX,0			; 初始化寄存器

MOV		SS,AX

MOV		SP,0x7c00

MOV		DS,AX

MOV		ES,AX


```
