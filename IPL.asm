; hello-os
; TAB=4

; note


		DB		0xeb, 0x4e, 0x90
		DB		"HELLOIPL"    ; note
		DW		512				    ; note
		DB		1				      ; note
		DW		1				      ; note
		DB		2				      ; note
		DW		224				    ; note
		DW		2880			    ; note
		DB		0xf0			    ; note
		DW		9				      ; note
		DW		18				    ; note
		DW		2				      ; note
		DD		0				      ; note
		DD		2880			    ; note
		DB		0,0,0x29		  ; note
		DD		0xffffffff		; note
		DB		"HELLO-OS   "	; note
		DB		"FAT12   "		; note
		RESB	18				    ; note

; note

		DB		0xb8, 0x00, 0x00, 0x8e, 0xd0, 0xbc, 0x00, 0x7c
		DB		0x8e, 0xd8, 0x8e, 0xc0, 0xbe, 0x74, 0x7c, 0x8a
		DB		0x04, 0x83, 0xc6, 0x01, 0x3c, 0x00, 0x74, 0x09
		DB		0xb4, 0x0e, 0xbb, 0x0f, 0x00, 0xcd, 0x10, 0xeb
		DB		0xee, 0xf4, 0xeb, 0xfd

; note

		DB		0x0a, 0x0a		      ; note
		DB		"hello, world"
		DB		0x0a			          ; note
		DB		"markOS is running!"
		DB		0

		RESB	0x1fe-$			; note

		DB		0x55, 0xaa

; note

		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		RESB	4600
		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		RESB	1469432
