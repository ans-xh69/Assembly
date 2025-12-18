include emu8086.inc
.model small
.stack 100h
.data

    msg_enter    db 'Enter a number (0-65535): $'
    msg_prime    db 'The number is prime.$'
    msg_notprime db 'The number is not prime.$'
    msg_title    db 'Prime Number Checker$'
    msg_invalid  db 'Invalid input. Please enter a number 0-65535.$'

    num dw 0              ; holds the entered number (0..65535)

.code

newline proc
    push ax
    push dx

    mov ah, 2
    mov dl, 10
    int 21h

    mov ah, 2
    mov dl, 13
    int 21h

    pop dx
    pop ax
    ret
newline endp

main proc
    mov ax, @data
    mov ds, ax

; Print title at top center
mov ah, 02h
mov bh, 0  
mov dh, 0  
mov dl, 30 
int 10h

mov dx, offset msg_title
mov ah, 09h  
int 21h

call newline 

input_loop:  
    call newline
    ; print prompt
    mov dx, offset msg_enter
    mov ah, 9
    int 21h

    ; reset number and flags
    mov word ptr num, 0
    mov si, 0          ; digit counter

read_digit_loop:
    mov ah, 1          ; read character
    int 21h
    cmp al, 13         ; Enter key
    je read_done
    cmp al, '0'
    jb read_digit_loop
    cmp al, '9'
    ja read_digit_loop

    sub al, '0'
    mov bl, al
    mov ax, word ptr num
    mov cx, 10
    mul cx
    add ax, bx
    adc dx, 0
    cmp dx, 0
    jne invalid_input
    mov word ptr num, ax
    inc si
    jmp read_digit_loop

read_done:
    cmp si, 0
    je invalid_input

    call newline

    mov ax, word ptr num

    cmp ax, 2
    jb invalid_input
    cmp ax, 2
    je print_prime

    mov bx, 2
    xor dx, dx
    div bx
    mov di, ax

    mov cx, 2
check_divisor_loop:
    mov ax, word ptr num
    xor dx, dx
    div cx
    cmp dx, 0
    je print_notprime
    inc cx
    cmp cx, di
    jle check_divisor_loop

print_prime:
    call newline
    mov dx, offset msg_prime
    mov ah, 9
    int 21h
    jmp finish

print_notprime:
    call newline
    mov dx, offset msg_notprime
    mov ah, 9
    int 21h
    jmp finish

invalid_input:
    call newline
    mov dx, offset msg_invalid
    mov ah, 9
    int 21h
    jmp input_loop

finish:
    mov ah, 4Ch
    int 21h

main endp
end main