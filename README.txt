BLoC - Binary Load Compressor: recovered source
Recovered 25 October 2026 from the owner's supplied executable.

RESULT

Compiler family: Monarch Data Systems ABC (A BASIC Compiler).
Embedded runtime: exact match to the archived ABC version 1.02 INTERP.X26.
The recovered tokenized BASIC source was compiled with that original compiler
under 6502 CPU emulation. Its output is byte-for-byte identical to the supplied
7,970-byte executable, including its runtime, bytecode, and load/run records.

Both executables have this SHA-256:
222976a5c4bf011914080a541dab224bd5928f5996b2effaec7771ad8250dd46

FILES

BLoC_recovered.txt  Readable listing, with descriptive replacement variable
                    names and the 63 original surviving line numbers.
BLoC_recovered.lst  Atari ENTER-format listing: short replacement names,
                    original string bytes, and ATASCII $9B line endings.
BLoC_recovered.bas  Tokenized Atari BASIC source. This is the source used for
                    the exact rebuild. It preserves all 19 variable slots,
                    including the unused slot, in their original order.
BLoC_rebuilt.xex    Result produced by the original ABC 1.02 compiler.
BLoC_bytecode.txt  Addressed bytecode disassembly, including all literals.
BLoC_notes.txt     Memory map, variable dictionary, and code walkthrough.
verification.txt  Verification output and the original compiler's transcript.
tools/             Purpose-built recovery scripts and the original executable.

The .txt listing spells nonprinting and inverse-video bytes as {HH}, where HH
is hexadecimal. For example, {00} means a single zero byte. Those braces are
display notation, not literal source text. The .lst and .bas preserve the
actual bytes, including the machine-code string used in line 50.

USING THE SOURCE

For the most faithful starting point, put BLoC_recovered.bas on an Atari disk
image under a short name such as BLOC.BAS, and use LOAD "D:BLOC.BAS" in Atari
BASIC to inspect or edit it. Compile it with ABC using INTERP.X26 to run it as
the original stand-alone utility. Merely entering the .lst into a fresh BASIC
session rebuilds the variable table in encounter order and drops the unused
slot; that source retains the logic but will not rebuild identical bytes.

This is recovered ABC-targeted BASIC. ABC uses integer arithmetic, and the
program also reads the ABC runtime's error byte at 195. It is not a verified
port to uncompiled Atari BASIC or another BASIC dialect. The original compiler
can discard constructs such as INT, so their original spelling cannot be
recovered from its bytecode. Direct RUN under stock BASIC has not been tested.

WHAT WAS AND WAS NOT RECOVERED

Recovered: all 63 surviving numbered lines, all 273 statements in the recovered
representation, all 62 string literals, the control flow, numeric constants,
variable references, and the six-byte machine-code helper. The 3,231 bytes of
program bytecode decode completely; there are no unknown-opcode placeholders.

Not recoverable: original variable names, removed REM comments, whitespace,
abbreviations, and source spellings that compile to the same code. The names
in these files were assigned during recovery. OPEN and XIO 3, for example,
can have the same compiled representation. The exact executable reproduction
proves the recovered source's compiled equivalence, not textual identity with
the lost source. No suspected original bugs were silently corrected.

VERIFICATION

1. Matched the embedded runtime against the reference INTERP.X26. Only the
   six program-address bytes and the two RUNAD bytes differ before linking.
2. Decoded the entire program into expressions and statements. A separate
   emitter recreated all 3,231 original program bytes from that semantic tree.
3. Tokenized the native listing with dmsc/basicParser v12 in Atari BASIC mode:
   63 lines, maximum tokenized line length 188 bytes.
4. Restored the original variable-slot order and the unused slot in the .bas.
5. Executed the original ABC 1.02 compiler on a py65 6502 CPU with in-memory
   Atari CIO and floating-point conversion shims. It reported COMPILE COMPLETE.
6. Compared the complete rebuilt file with the supplied executable: identical.

This did not require running BLoC's disk-format or file-deletion commands.
The compiler's disk operations were confined to an in-memory file dictionary.
No full Atari hardware or disk-image execution test of BLoC was performed.

REPRODUCING THE RECOVERY (Windows, Python 3)

Extract this ZIP, then run the following from its root. Network access is
needed only for the reference downloads and the optional Python dependency.
basicParser and the archived compiler are downloaded, not included in this ZIP.

  python tools/decompile.py
  python tools/verify_roundtrip.py
  python tools/fetch_reference.py
  tools\basicParser.exe -A -b -f -n 255 -o tools/BLoC.bas outputs/BLoC_recovered.lst
  python tools/restore_variable_slots.py
  python -m pip install --target tools/pylibs py65==1.2.0
  python tools/run_abc.py
  python tools/compare_compiled.py

The final command asserts equality of the complete original and rebuilt files.
The recovery scripts target this supplied executable, not arbitrary ABC files.

REFERENCES

ABC original reference manual (describes P-code and integer arithmetic):
https://atarionline.pl/utils/4.%20Programowanie/ABC%20A%20Basic%20Compiler/ABC%20A%20Basic%20Compiler.pdf

Archived compiler disk and runtime: precise download URL in
tools/fetch_reference.py. The disk is labelled ABC 1.02 and the executing
compiler identifies itself as "A BASIC Compiler Version 1.O2".

Atari BASIC tokenizer, by dmsc:
https://github.com/dmsc/tbxl-parser

6502 CPU emulator used for verification:
https://github.com/mnaberez/py65
