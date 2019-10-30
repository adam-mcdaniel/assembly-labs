; ***********************************************************************
; *  File : lab1.asm
; *  Author : Adam McDaniel
; *  Description: computes x^y
; *  Register use:
;       eax: holds result of x^y
; ***********************************************************************

.386
.MODEL FLAT
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
PUBLIC _start   ; make procedure _start public
; ***********************************************************************
; *                     Data Segment                                 
; ***********************************************************************
.DATA
	x DWORD -5
	y DWORD 3

; ***********************************************************************
; *                     Stack Segment                                 
; ***********************************************************************
.STACK  4096
; ***********************************************************************
; *                     Code Segment                                  
; ***********************************************************************
.CODE
power PROC NEAR32 ; begin power
        push ebp  ; establish power stack frame
        mov ebp, esp    
        pushfd    ; save flags

        mov eax, 1 ; eax = accumulator
        mov ebx, [ebp+12] ; ebx = 1st parameter
        mov ecx, [ebp+8]  ; ecx = 2nd parameter

        ; CALCULATE x^y
        cmp ecx, 0 ; if y is 0, then dont execute loop (eax is 1)
        je endloop
        beginloop: ; if y is not zero, perform x^y
            imul eax, ebx ; multiply accumulator by x
            dec ecx       ; decrement counter
            cmp ecx, 0    ; if counter is zero, stop
            jg beginloop
        endloop: ; end of loop body

        popfd             ; pop flags
        pop ebp           ; restore calling stack frame
        ret	   ; pops address off stack into EIP
power ENDP ; end power

_start  PROC    NEAR32
        push x
        push y
        call power ; power(x, y)

; ***********************************************************************
; *                     Magic Segment                                  
; ***********************************************************************
exit:   EVEN
        INVOKE  ExitProcess, 0
_start  ENDP
        END
