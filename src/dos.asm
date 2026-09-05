;
; ref: https://stanislavs.org/helppc/int_21.html
;
; void tiny_dos_init(uint16_t cx, uint16_t dx)
; CX = CS
; DX = PSP
tiny_dos_init:
	cli                  ; disable interrupts

	xor bx, bx
	mov es, bx

	; install our custom `int 21h` interrupt handler into the IVT
	mov word [es:0084h], tiny_dos_int21_stub
	mov word [es:0086h], cx

	; install our custom `int 20h` interrupt handler into the IVT
	mov word [es:0080h], tiny_dos_int20_stub
	mov word [es:0082h], cx

	mov es, dx
	mov ds, dx

	xor si, si
    xor di, di

	sti                  ; enable interrupts

.init_psp:
	mov ax, 20CDh        ; CD20 = int 20h
	stosw                ; store AX in [ES:DI]

	xor ax, ax           ; set AX to zero
	mov cx, 07Fh         ; 128 - 1 = 127
	rep stosw            ; store AX in [ES:DI]

.reset_reg:
	xor di, di

	;
	; Might be desirable to set these to certain specific or common values to
	; mimic *real* M$-DOS in a more faithful manner.
	;
	; But since TinySol doesn't seem to depend redisual values
	; in these registers, it's better to just zero them out.
	;
	xor bx, bx
	xor cx, cx
	xor dx, dx

	ret

tiny_dos_int21_stub:
	cmp ah, 04Ch
	je tiny_dos_int20_stub

	cmp ah, 03Ch
	je .open_file_handle

	cmp ah, 03Dh
	je .open_file_handle

	cmp ah, 03Fh
	je .read_write_file_handle

	cmp ah, 03Eh
	je .close_file_handle

	cmp ah, 040h
	je .read_write_file_handle

	cmp ah, 06h
	je .direct_console_io

	cmp ah, 09h
	je .print_string

.not_implemented:
	call halt
	iret                       ; unreachable, included for consistency!

.open_file_handle:
	mov ax, 0CACAh             ; sorry, not sorry!
	jmp .close_file_handle

.read_write_file_handle:
	xor ax, ax
	xor cx, cx

.close_file_handle:
	clc
	iret

.direct_console_io:
	cmp dl, 0FFh               ; no direct reading at this time!
	je .not_implemented

	mov ah, 0Eh                ; write character to console
	mov al, dl                 ; input character comes in dl
	mov bx, TINYSOL_TEXT_ATTR  ; we always reset BX because it can get clobbered
	int 10h

	iret

.print_string:
	mov si, dx
	call puts
	iret

tiny_dos_int20_stub:
	push cs
	pop ds                     ; we trash DS since where our collective asses are going, there won't be no callback!

	call set_text_mode

	mov si, .message
	call puts

	call halt                  ; halt and catch fire!

	iret                       ; unreachable, included for consistency!

.message: db 'Thanks for playing!', 10, 13, 10, 13, "It's now safe to turn off your computer!", 10, 13, '$'
