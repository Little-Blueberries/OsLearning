bits 16

section _TEXT class=CODE

;
; int 10h, ah = 0Eh
; args: characters, pages
;
global _x86_Video_WriteCharTeletype
_x86_Video_WriteCharTeletype:
    ; Make new call frame
    push bp                 ; Save old cell frame
    mov bp, sp              ; Intialize new cell frame

    ; Save bx
    push bx

    ; [bp + 0] - old cell frame
    ; [bp + 2] - return address (small memory mode) => 2 bytes
    ; [bp + 4] - first argument (character)
    ; [bp + 6] - second argument (page)
    ; note: bytes are converted to words (you can't push a single byte into the stack)
    mov ah, 0Eh
    mov al, [bp + 4]
    mov bh, [bp + 6]

    int 10h
    pop bx              ; Restore bx

    ; Restore cell frame
    mov sp, bp
    pop bp
    ret