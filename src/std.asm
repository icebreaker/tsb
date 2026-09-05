; void set_text_mode(void)
set_text_mode:
	mov ax, 03h                ; text 80x25 @ 16 color mode
	int 10h
	ret

; void halt(void)
halt:
	hlt
	jmp halt                   ; halt me baby, one more time!

; void puts(const char *si)
puts:
	mov ah, 0Eh
	mov bx, TINYSOL_TEXT_ATTR  ; we always reset BX because it can get clobbered

.next:
	lodsb                      ; load byte from [DS:SI] into AL

	cmp al, '$'                ; '$' = end of string?
	je .end

	int 10h
	jmp .next
.end:
	ret
