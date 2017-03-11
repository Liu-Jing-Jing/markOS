; mark-os boot asm 前半部分汇编 后半部分C写的
; TAB=4

BOTPAK	EQU		0x00280000		; bootpackのロード先
DSKCAC	EQU		0x00100000		; 磁盘缓存的位置
DSKCAC0	EQU		0x00008000		; 磁盘缓存的位置(Real模式下)

; BOOT_INFO相关信息
CYLS	EQU		0x0ff0			    ; boot sector的设定
LEDS	EQU		0x0ff1
VMODE	EQU		0x0ff2			    ; 色数に関する情報。何ビットカラーか？
SCRNX	EQU		0x0ff4			    ; 解像度のX
SCRNY	EQU		0x0ff6			    ; 解像度のY
VRAM	EQU		0x0ff8			    ; 图像缓冲区的开始地址

		ORG		0xc200			      ; 程序被装载到内存的这个位置

; 画面モードを設定
		MOV		AL,0x13			      ; VGAグラフィックス、320x200x8bitカラー
		MOV		AH,0x00
		INT		0x10
		MOV		BYTE [VMODE],8	  ; 画面モードをメモする（C言語が参照する）
		MOV		WORD [SCRNX],320
		MOV		WORD [SCRNY],200
		MOV		DWORD [VRAM],0x000a0000

; キーボードのLED状態をBIOSに教えてもらう

		MOV		AH,0x02
		INT		0x16 			; keyboard BIOS
		MOV		[LEDS],AL


; 新增加的100行代码,然后进入保护模式和32位(需要重点学习)
; 这个文件重命名为asm head.asm  然后和bootpack.C文件链接 
