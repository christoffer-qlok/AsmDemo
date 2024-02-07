ExitProcess PROTO
GetStdHandle PROTO
ReadConsoleA PROTO
WriteConsoleA PROTO

.data

std_out_handle QWORD ?
std_in_handle QWORD ?
prompt byte "Enter name: ",0
bytes_written QWORD ?
buffer byte 128 dup(?)
bytes_read QWORD ?
greeting byte "Hello ", 0

.code
main PROC
    sub rsp, 5 * 8             ; reserve shadow space

    ; Get std out handle
    mov rcx, -11
    call GetStdHandle

    mov std_out_handle, rax
    
    ; Write prompt to console
    mov rcx, rax
    lea rdx, prompt
    mov r8, LENGTHOF prompt - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA

    ; Get std in handle
    mov rcx, -10
    call GetStdHandle

    mov std_in_handle, rax

    ; Read users name from console
    mov rcx, rax
    lea rdx, buffer
    mov r8, 128
    lea r9, bytes_read
    push 0
    call ReadConsoleA


    ; Write a greeting
    mov rcx, std_out_handle
    lea rdx, greeting
    mov r8, LENGTHOF greeting - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA

    ; Write users name to console
    mov rcx, std_out_handle
    lea rdx, buffer
    mov r8, bytes_read
    lea r9, bytes_written
    push 0
    call WriteConsoleA

    mov rcx, rax                  ; uExitCode
    call ExitProcess

main ENDP
END
