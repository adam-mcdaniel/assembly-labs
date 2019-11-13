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
NUMELEMENTS EQU 10
; ***********************************************************************
; *                     Data Segment                                 
; ***********************************************************************
.DATA
	n DWORD NUMELEMENTS
	array DWORD NUMELEMENTS DUP (0)

; ***********************************************************************
; *                     Stack Segment                                 
; ***********************************************************************
.STACK  4096
; ***********************************************************************
; *                     Code Segment                                  
; ***********************************************************************
.CODE



sort PROC NEAR32
        push ebp  ; establish sort stack frame
        mov ebp, esp    
        pushfd    ; save flags
        ; CODE BEGIN
        push eax
        push ebx
        push ecx
        push edx

        mov eax, [ebp+12]  ; eax = array address
        mov ebx, [ebp+8]   ; ebx = num elements in array

        dec ebx ; ebx is n-1
        ; for (i=0; i<n-1; i++)
        mov ecx, 0 ; i = 0;
        topbegin:
            cmp ecx, ebx; i < n-1
            jg topend

            ; for (j=0; j<n-i-1; j++)
            mov edx, 0 ; j = 0;
            nestedbegin:
                push eax
                push ebx
                push ecx

                cmp edx, ebx ; j < n - 1
                jge nestend


                mov ebx, [eax+4*edx] ; arr[j]
                mov ecx, [eax+4*edx+4] ; arr[j+1]
                cmp ebx, ecx ; if (ebx > ecx) goto doswap;
                jle dontswap
                doswap:
                    mov ebx, 4 ; ebx = &arr[j]
                    imul ebx, edx
                    add ebx, eax
                    mov ecx, ebx
                    add ecx, 4

                    push ebx
                    push ecx
                    call swap ; swap(ebx, ecx)

                    ; clean up stack!
                    add esp, 8
                    ; finished cleaning up stack!
                dontswap:
                

                pop ecx
                pop ebx
                pop eax

                inc edx
                jmp nestedbegin
            nestend:
                pop ecx
                pop ebx
                pop eax

            inc ecx
            jmp topbegin
        topend:
        
        pop edx
        pop ecx
        pop ebx
        pop eax
        ; CODE END
        popfd             ; pop flags
        pop ebp           ; restore calling stack frame
        ret	   ; pops address off stack into EIP
sort ENDP ; end sort


swap PROC NEAR32 ; begin swap
        push ebp  ; establish swap stack frame
        mov ebp, esp    
        pushfd    ; save flags
        ; CODE BEGIN
        push eax
        push ebx
        push ecx

        mov eax, [ebp+12]  ; eax = address 1
        mov ebx, [ebp+8]   ; ebx = address 2
        
        push [eax]
        push [ebx]
        pop [eax]
        pop [ebx]


    
        pop ecx
        pop ebx
        pop eax
        ; CODE END
        popfd             ; pop flags
        pop ebp           ; restore calling stack frame
        ret	   ; pops address off stack into EIP
swap ENDP ; end swap

_start  PROC    NEAR32
        ; sorted is
        ; 0 0 1 1 2 2 5 7 8 10
        mov [array], 5
        mov [array+4], 1
        mov [array+8], 2
        mov [array+12], 10
        mov [array+16], 7
        mov [array+20], 8
        mov [array+24], 1
        mov [array+28], 2
        mov [array+32], 0
        mov [array+36], 0

        lea eax, array
        push eax
        push n
        call sort ; power(x, y)
        ; clean up stack!
        add esp, 8

; ***********************************************************************
; *                     Magic Segment                                  
; ***********************************************************************
exit:   EVEN
        INVOKE  ExitProcess, 0
_start  ENDP
        END
