bits 16

section _TEXT class=CODE

;
; void _cdecl x86_div64_32(uint64_t dividend, uint32_t divisor, uint64_t* quotientOut, uint64_t* remainderOut);
;
global _x86_div64_32
_x86_div64_32:
    ; Make new call frame
    push bp                 ; Save old cell frame
    mov bp, sp              ; Intialize new cell frame

	push bx

    ; Divide upper 32 bits
    mov eax, [bp + 4]       ; eax <- upper 32 bits of dividend
    mov ecx, [bp + 12]      ; eax <- divisor
    xor edx, edx
    div ecx                 ; eax = quote, edx = remainder

    ; Store upper 32 bits of quotient
    mov bx, [bp + 16]
    mov [bx + 4], eax

    ; Divide lower 32 bits
    mov eax, [bp + 4]       ; eax <- lower 32 bits of dividend
                            ; edx <- old remainder
	div ecx

	; Store result
	mov [bx], eax
	mov bx, [bp + 18]
	mov [bx], edx

	pop bx

    ; Restore cell frame
    mov sp, bp
    pop bp
    ret


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