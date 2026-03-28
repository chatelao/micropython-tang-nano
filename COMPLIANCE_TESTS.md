# MicroPython Compliance Test Results

```
--- /app/src/lib/micropython/tests/results/basics_io_iobase.py.exp	2026-03-28 11:56:32.861907754 +0000
+++ /app/src/lib/micropython/tests/results/basics_io_iobase.py.out	2026-03-28 11:56:32.861907754 +0000
@@ -1,2 +1,4 @@
-write 4
-write 1
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+TypeError:
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/basics_struct_endian.py.exp	2026-03-28 11:56:32.921907753 +0000
+++ /app/src/lib/micropython/tests/results/basics_struct_endian.py.out	2026-03-28 11:56:32.921907753 +0000
@@ -1,6 +1,4 @@
-(12849,)
-(875770417,)
-(875770417,)
-(875770417, 943142453)
-bytearray(b'>3210<<<<<<<')
-bytearray(b'>327654DCBA<')
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NameError:
+CRASH
\ No newline at end of file

FAILURE /app/src/lib/micropython/tests/results/basics_io_iobase.py

FAILURE /app/src/lib/micropython/tests/results/basics_struct_endian.py

```
