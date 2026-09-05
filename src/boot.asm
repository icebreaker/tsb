;
; Guard and define these on the fly in case someone is building or including
; this outside of the provided `Makefile`.
;
%ifndef TINYSOL_COM
	%define TINYSOL_COM 'vendor/tinysol/TINYSOL.COM'
%endif

%ifndef TINYSOL_TEXT_ATTR
	%define TINYSOL_TEXT_ATTR 0000Fh
%endif

;
; What is the charge? Doing napkin math? Some succulent napkin math?
;
;  1 paragraph  = 16 bytes
; 32 paragraphs = 512 bytes
;
; 1 sector			= 512 bytes
; 1 cylinder/track	= 18 sectors
; 1 side			= 80 cylinders/tracks
; 1 disk (1'44 MB)	= 2 sides
;
; 2 * 80 * 18 * 512 = 1474560 (B) = 1440 (KB) = 1.44 (MB)
;
%define SECTORS 8                 ; 4096 bytes in paragraphs
%define IMAGE_SIZE SECTORS * 512  ; SECTORS * 512 bytes (32 paragraphs)

bits 16                           ; 16 bit mode
								  ; org = 07C0h

;
; This *arcane voodoo* is pretty much necessary in order to ensure that we can
; boot on some more *modern systems*, especially various laptops that seem to
; inspect and even write into the BPB on boot. Oh well!
;
; 0xEB, 0x76, 0x90
jmp _start                        ; jump to _start
nop                               ;
OEM_NAME: db 'TINYSOLB'           ; OEM NAME
times 71 db 0                     ; reserve some empty space for the BPB (assume FAT32)

_start:
	cli                           ; disable interrupts

	mov ax, 07C0h	              ; org = 07C0h
	mov ds, ax
	mov es, ax

	mov ss, ax                    ; set stack segment
	xor sp, sp                    ; set stack pointer to the very end of the stack segment
                                  ; 0000h is just fine, because it will wrap around to 0FFFEh, 0xFFFCh and so forth

	sti                           ; enable interrupts

	cld                           ; reset direction flag (just in case!)

	;
	; Considering the fact that we should have some more bytes to spare here, it might be nice to
	; implement an M$ W1nd0z style `Press any key to boot from CD or DVD...` boot prompt
	; that simply waits for a key press for something like 5 seconds, then proceeds booting
	; from the next drive, if no key was pressed.
	;
	; Decisions, decisions ...
	;
	mov si, boot_intro_msg
	call puts

	xor cx, cx

.disk_reset:
	push cx

	xor ax, ax                   ; reset disk function
	int 13h

	jc .disk_reset_error

.disk_read:
	mov bx, 0300h                ; 07F0h = 07C0h + 512 (BOOT SECTOR) + 256 (PSP)

	xor dh, dh                   ; head number
	                             ; drive number (dl)

	xor ch, ch                   ; cylinder number
	mov cl, 2                    ; starting sector number

	mov ah, 02h                  ; read sectors function
	mov al, SECTORS - 1          ; number of sectors to read (minus the BOOT SECTOR)

	int 13h

	jc .disk_read_retry

.init_tiny_dos:
	mov cx, 07C0h                ; CS
	mov dx, 07E0h                ; ES, DS = PSP
	call tiny_dos_init           ; Ade due Damballa. Give me the power, I beg of you!

	cli                          ; disable interrupts

	mov ax, 07E0h
	mov ss, ax                   ; set stack segment
	xor sp, sp                   ; set stack pointer to the very end of the stack segment
                                 ; 0000h is just fine, because it will wrap around to 0FFFEh, 0xFFFCh and so forth

	sti                          ; enable interrupts

    xor ax, ax                   ; push 0000h into the stack so that 'ret'
	push ax						 ; will end up jumping back to 07E0h:0000h, which then will execute the `int 20h`

	jmp 07E0h:0100h              ; far jump to 0100h

.disk_read_retry:
	pop cx
	inc cx

	cmp cx, 03h                  ; retry at most 3 times (should be enough for everybody, eh?)
	jl .disk_reset

.disk_read_error:
	mov si, disk_read_error_msg
	jmp .print_error

.disk_reset_error:
	mov si, disk_reset_error_msg

.print_error:
	call puts
	call halt

boot_intro_msg: db 'BOOTING TINYSOL ...', 10, 13, '$'
disk_reset_error_msg: db 'ERROR: COULD NOT RESET DISK ...', 10, 13, '$'
disk_read_error_msg: db 'ERROR: COULD NOT READ DISK ...', 10, 13, '$'

%include 'std.asm'
%include 'dos.asm'

times 510 - ($ - $$) db 0        ; pad to 510 bytes
dw 0xAA55                        ; pad 2 more bytes = 512 bytes = THE BOOT SECTOR

incbin TINYSOL_COM

times IMAGE_SIZE - ($ - $$) db 0 ; pad to IMAGE_SIZE
