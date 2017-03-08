# markOS
## Current Version beta 0.1.7(day4)
- [学习笔记更新](https://github.com/Liu-Jing-Jing/markOS/wiki)
## ReleaseNote
- Version: beta 0.0.8 将磁盘的启动扇区和C0-H0-S2读入内存中
- Version: beta 0.0.9 将磁盘的启动扇区和C0-H0-S2到S17.算上boot sector共18个扇区读入内存中
- Version: beta 0.1.0 将磁盘的启动扇区和C0-H0-S2到第10个柱面的C9-H1-S17读入内存中,共10个柱面.内存占用180KB


```
[代码块](https://github.com/Liu-Jing-Jing/markOS/blob/master/helloOS.asm)
entry:

MOV		AX,0			; 初始化寄存器

MOV		SS,AX

MOV		SP,0x7c00

MOV		DS,AX

MOV		ES,AX


```
