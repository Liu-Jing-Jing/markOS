; hello-os
; TAB=4
    	CYLS	EQU		10    	                    	; 类似于C语言的宏定义，定义常量10.代表10个柱面
		ORG		0x7c00
; 软驱的信息
		JMP		entry
		DB		0x90
		DB		"HELLOIPL"			;
		DW		512			      	;
		DB		1			        ;
		DW		1			        ;
		DB		2			        ;
		DW		224			      	;
		DW		2880			        ;
		DB		0xf0			        ;
		DW		9			        ;
		DW		18			      	;
		DW		2			        ;
		DD		0			        ;
		DD		2880			        ;
		DB		0,0,0x29		  	;
		DD		0xffffffff			;
		DB		"MARK-OS-IPL"		        ; 磁盘名称(必须11字节)
		DB		"FAT12   "			;
		RESB	18				        ;


; note
entry:
		MOV		AX,0				; 初始化寄存器
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

; 加载入内存
		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0				; 软盘柱面0, 也是第一个柱面		
		MOV		DH,0				; 软盘的磁头0,正面的磁头		
		MOV		CL,2				; 软盘的第二个扇区,C0-H0-S2		
		
		readloop:
		MOV		SI,0            		; 记录尝试的次数
retry:
		MOV		AH,0x02				; AH = 0x02代表的意思是读盘			
		MOV		AL,1				; 只处理1个扇区			
		MOV		BX,0
		MOV		DL,0x00				; 代表A驱动器号			
		INT		0x13				; 调用BIOS的第19号与磁盘有关的函数			
		JNC		next
		ADD		SI,1
		CMP		SI,5
		JAE		error
		MOV		AH,0x00
		MOV		DL,0x00
		INT		0x13
		JMP		retry
		
next:
		MOV		AX,ES			
		ADD		AX,0x0020
		MOV		ES,AX			
		ADD		CL,1			
		CMP		CL,18			
		JBE		readloop
		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB		readloop			; DH < 2代表正反面
		MOV		DH,0   				; 开始读取下一个柱面
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop			; CH < CYLS


fin:
		HLT						; CPU休眠的指令
		JMP		fin				;
error:
		MOV		SI,msg				; 错误信息


putloop:
		MOV		AL,[SI]
		ADD		SI,1				;
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e				;
		MOV		BX,15				;
		INT		0x10				;
		JMP		putloop


; 信息显示部分
msg:
		DB		0x0a, 0x0a
		DB		"load error"
; 换行
		DB		0x0a, 0x0a		
		DB		"markOS"
		DB		0
		RESB	        0x7dfe-$			; 利用0x00填充到0x1fe为止		
		
		DB		0x55, 0xaa

; 0x55, 0xaa是引导扇区结束的标识
