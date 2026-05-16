; LPT1.ASM — Envío de un carácter al puerto paralelo LPT1
; Compila: nasm -f bin LPT1.ASM -o LPT1.COM

[BITS 16]
[ORG 0x100]

DATA_PORT EQU 0378h
STATUS_PORT EQU 0379h
CTRL_PORT EQU 037Ah

start:
 ; Esperar BUSY=1 (impresora lista)
 MOV DX, STATUS_PORT    ; Pasamos el puerto de 16 bits a DX

 .wait_ready:
 IN AL, DX              ; Lee el puerto de estado (0379h)
 TEST AL, 80h           ; Revisa el bit 7 (BUSY)
 JZ .wait_ready         ; Si es 0 (ocupado), salta al inicio de .wait_ready
 
 ; Enviar carácter "A" (0x41)
 MOV AL, 41h
 MOV DX, DATA_PORT      ; Cambiamos DX al puerto de datos
 OUT DX, AL             ; Enviamos el dato usando DX

 ; Pulso STROBE (bit 0 del control, activo en bajo)
 MOV DX, CTRL_PORT      ; Cambiamos DX al puerto de control
 IN AL, DX              ; Leemos el estado actual usando DX
 AND AL, 0FEh           ; STROBE=0 → activo
 OUT DX, AL             ; Escribimos usando DX

 ; Retardo mínimo (~1µs en DOSBox)
 MOV CX, 0Fh
.delay: LOOP .delay
 OR AL, 01h ; STROBE=1 → inactivo
 OUT DX, AL ; Escribimos (DX todavía tiene el valor CTRL_PORT)

 MOV AH, 4Ch
 INT 21h