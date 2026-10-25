; BLoC - embedded 6502 block-read helper, recovered from BASIC line 50.
; Verified original bytes: 68 A2 10 4C 56 E4
; Loaded address in this executable: $3AAB-$3AB0.
; The helper itself can execute at any address.
;
; BASIC calls it with USR(ADR(machine-code-string)), with no arguments.
; BASIC line 40 prepares IOCB #1 beforehand:
;   $0352 / 850       = 7                (GET CHARACTERS / binary read)
;   $0354-$0355       = ADR(BUF$)+4      (destination, low byte first)
;   $0358-$0359       = LAST-START+1     (byte count, low byte first)
;
; IOCB #1 was opened for input in BASIC line 30. Its file position is now
; just after the segment header. BUF$ already contains the four header bytes,
; so the block read writes the payload starting at the fifth string byte.

CIOV = $E456

read_block:
    PLA             ; $3AAB: 68       Remove USR argument count, which is zero.
    LDX #$10        ; $3AAC: A2 10    Select IOCB #1: 1 * 16-byte IOCB size.
    JMP CIOV        ; $3AAE: 4C 56 E4 Call CIO using the existing return address.

; CIO's eventual RTS returns to the ABC USR continuation at $311F.
; A JSR CIOV / RTS sequence would be equivalent here but one byte longer.
; There is no explicit I/O-status test or numeric USR-result setup in the
; helper. BASIC assigns the USR result to HI, then overwrites HI with 4.
;
; This supplies a bulk read into string memory, avoiding a BASIC GET loop.
; The compression logic itself is in BASIC.
