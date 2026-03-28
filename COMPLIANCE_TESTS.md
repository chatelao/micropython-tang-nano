# MicroPython Compliance Test Results

```
--- /app/src/lib/micropython/tests/results/basics_namedtuple1.py.exp	2026-03-28 10:27:41.778122635 +0000
+++ /app/src/lib/micropython/tests/results/basics_namedtuple1.py.out	2026-03-28 10:27:41.778122635 +0000
@@ -7,28 +7,7 @@
 (1, 2, 1, 2, 1, 2)
 [1, 2]
 True
-(1, 2)
-True True
-Tup(foo=2, bar=1)
-2 1
-2 1
-2
-True
-(2, 1, 2, 1)
-(2, 1, 2, 1, 2, 1)
-[2, 1]
-True
-(2, 1)
-True True
-Tup(foo=3, bar=4)
-TypeError
-AttributeError
-TypeError
-TypeError
-TypeError
-TypeError
-TypeError
-TypeError
-1 2
-1 2
-TupEmpty()
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+TypeError: unsupported type for operator
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/basics_array1.py.exp	2026-03-28 10:27:38.782122668 +0000
+++ /app/src/lib/micropython/tests/results/basics_array1.py.out	2026-03-28 10:27:38.782122668 +0000
@@ -91,10 +91,10 @@
 False
 True
 False
-False
-True
-True
 True
+False
 True
 False
+True
 False
+True
--- /app/src/lib/micropython/tests/results/basics_io_iobase.py.exp	2026-03-28 10:29:23.954121484 +0000
+++ /app/src/lib/micropython/tests/results/basics_io_iobase.py.out	2026-03-28 10:29:23.954121484 +0000
@@ -1,2 +1,4 @@
-write 4
-write 1
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+TypeError: argument num/types mismatch
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/basics_struct_endian.py.exp	2026-03-28 10:27:01.262123091 +0000
+++ /app/src/lib/micropython/tests/results/basics_struct_endian.py.out	2026-03-28 10:27:01.262123091 +0000
@@ -1,6 +1,2 @@
-(12849,)
-(875770417,)
-(875770417,)
-(875770417, 943142453)
-bytearray(b'>3210<<<<<<<')
-bytearray(b'>327654DCBA<')
+OverflowError: long int not supported in this build
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/basics_memoryview_slice_size.py.exp	2026-03-28 10:27:36.750122691 +0000
+++ /app/src/lib/micropython/tests/results/basics_memoryview_slice_size.py.out	2026-03-28 10:27:36.750122691 +0000
@@ -1,2 +1,2 @@
-<memoryview>
-OverflowError
+OverflowError: long int not supported in this build
+CRASH
\ No newline at end of file

FAILURE /app/src/lib/micropython/tests/results/basics_namedtuple1.py

FAILURE /app/src/lib/micropython/tests/results/basics_array1.py

FAILURE /app/src/lib/micropython/tests/results/basics_io_iobase.py

FAILURE /app/src/lib/micropython/tests/results/basics_struct_endian.py

FAILURE /app/src/lib/micropython/tests/results/basics_memoryview_slice_size.py

```
