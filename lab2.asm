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
NUMELEMENTS EQU 4
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



; void swap(int *xp, int *yp)  
; {  
;     int temp = *xp;  
;     *xp = *yp;  
;     *yp = temp;  
; }  
  
; // A function to implement bubble sort  
; void bubbleSort(int arr[], int n)  
; {  
;     int i, j;  
;     for (i = 0; i < n-1; i++)      
      
;     // Last i elements are already in place  
;     for (j = 0; j < n-i-1; j++)  
;         if (arr[j] > arr[j+1])  
;             swap(&arr[j], &arr[j+1]);  
; }  
  

sort PROC NEAR32 ; begin power
        push ebp  ; establish power stack frame
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
            jge topend

            ; for (j=0; j<n-i-1; j++)
            mov edx, 0 ; j = 0;
            nestedbegin:
                push eax
                push ebx
                push ecx

                sub ebx, ecx ; j < n-i-1
                cmp edx, ebx
                jge nestend


                mov ebx, [eax+4*edx] ; arr[j]
                mov ecx, [eax+4*edx+4] ; arr[j+1]
                cmp ebx, ecx ; if (ebx > ecx) goto doswap;
                jle dontswap
                doswap:
                    mov ebx, eax ; ebx = &arr[0]
                    mov ecx, edx
                    imul ecx, 4
                    add ebx, ecx ; ebx = &arr[j]

                    add ecx, eax
                    add ecx, 4   ; ecx = &arr[j+1]

                    push ebx
                    push ecx
                    call swap ; swap(ebx, ecx)
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
sort ENDP ; end power

swap PROC NEAR32 ; begin power
        push ebp  ; establish power stack frame
        mov ebp, esp    
        pushfd    ; save flags
        ; CODE BEGIN
        push eax
        push ebx
        push ecx

        mov eax, [ebp+12]  ; eax = address 1
        mov ebx, [ebp+8]   ; ebx = address 2

        mov ecx, ebx
        mov ebx, [eax]
        mov eax, [ecx]
    
        pop ecx
        pop ebx
        pop eax
        ; CODE END
        popfd             ; pop flags
        pop ebp           ; restore calling stack frame
        ret	   ; pops address off stack into EIP
swap ENDP ; end power

_start  PROC    NEAR32
        mov [array], 5
        mov [array+4], 1
        mov [array+8], 2

        lea eax, array
        push eax
        push n
        call sort ; power(x, y)

        mov eax, [array]
        mov ebx, [array+4]
        mov ecx, [array+8]

; ***********************************************************************
; *                     Magic Segment                                  
; ***********************************************************************
exit:   EVEN
        INVOKE  ExitProcess, 0
_start  ENDP
        END
