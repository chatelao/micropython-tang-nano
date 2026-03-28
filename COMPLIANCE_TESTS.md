# MicroPython Compliance Test Results

```
--- /app/src/lib/micropython/tests/results/cpydiff_modules_struct_whitespace_in_format.py.exp	2026-03-28 15:57:17.708027312 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_struct_whitespace_in_format.py.out	2026-03-28 15:57:17.708027312 +0000
@@ -1,2 +1 @@
-b'\x01\x02'
-Should have worked
+struct.error
--- /app/src/lib/micropython/tests/results/cpydiff_types_float_implicit_conversion.py.exp	2026-03-28 15:57:18.744027300 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_float_implicit_conversion.py.out	2026-03-28 15:57:18.744027300 +0000
@@ -1,6 +1 @@
-CPYTHON3 CRASH:
-Traceback (most recent call last):
-  File "/app/src/lib/micropython/tests/cpydiff/types_float_implicit_conversion.py", line 14, in <module>
-    print(2.0 * Test())
-          ~~~~^~~~~~~~
-TypeError: unsupported operand type(s) for *: 'float' and 'Test'
+1.0
--- /app/src/lib/micropython/tests/results/basics_int_big1.py.exp	2026-03-28 15:56:32.572027820 +0000
+++ /app/src/lib/micropython/tests/results/basics_int_big1.py.out	2026-03-28 15:56:32.572027820 +0000
@@ -174,5 +174,7 @@
 -70368744177663
 70368744177664
 -70368744177664
-True
-aaaa
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+AttributeError: 'module' object has no attribute 'maxsize'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_str_formatsep.py.exp	2026-03-28 15:57:19.372027293 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_str_formatsep.py.out	2026-03-28 15:57:19.372027293 +0000
@@ -1,3 +1,3 @@
-ValueError
-ValueError
-ValueError
+110,0011
+63
+143
--- /app/src/lib/micropython/tests/results/cpydiff_syntax_arg_unpacking.py.exp	2026-03-28 15:57:17.840027310 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_syntax_arg_unpacking.py.out	2026-03-28 15:57:17.840027310 +0000
@@ -1 +1,4 @@
-67
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+SyntaxError: too many args
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_fstring_repr.py.exp	2026-03-28 15:57:16.400027326 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_fstring_repr.py.out	2026-03-28 15:57:16.400027326 +0000
@@ -0,0 +1,4 @@
+Traceback (most recent call last):
+  File "<stdin>"
+SyntaxError: invalid syntax
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_class_supermultiple.py.exp	2026-03-28 15:57:16.104027330 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_class_supermultiple.py.out	2026-03-28 15:57:16.104027330 +0000
@@ -1,4 +1,3 @@
 D.__init__
 B.__init__
-C.__init__
 A.__init__
--- /app/src/lib/micropython/tests/results/cpydiff_types_exception_loops.py.exp	2026-03-28 15:57:18.636027301 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_exception_loops.py.out	2026-03-28 15:57:18.636027301 +0000
@@ -1,8 +1,6 @@
-CPYTHON3 CRASH:
 iter
 iter
 Traceback (most recent call last):
-  File "/app/src/lib/micropython/tests/cpydiff/types_exception_loops.py", line 11, in <module>
-    while l[i][0] == "-":
-          ~^^^
+  File "<stdin>", in <module>
 IndexError: list index out of range
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_str_ljust_rjust.py.exp	2026-03-28 15:57:19.600027290 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_str_ljust_rjust.py.out	2026-03-28 15:57:19.600027290 +0000
@@ -1 +1,4 @@
-abc
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+AttributeError: 'str' object has no attribute 'ljust'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_class_initsubclass.py.exp	2026-03-28 15:57:15.608027335 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_class_initsubclass.py.out	2026-03-28 15:57:15.608027335 +0000
@@ -1 +1,4 @@
-Base.__init_subclass__(A)
+Traceback (most recent call last):
+  File "<stdin>"
+SyntaxError: invalid syntax
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_class_superproperty.py.exp	2026-03-28 15:57:16.168027329 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_class_superproperty.py.out	2026-03-28 15:57:16.168027329 +0000
@@ -1 +1,5 @@
-{'a': 10}
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+  File "<stdin>", in A
+NameError: name 'property' isn't defined
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_list_delete_subscrstep.py.exp	2026-03-28 15:57:18.976027297 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_list_delete_subscrstep.py.out	2026-03-28 15:57:18.976027297 +0000
@@ -1 +1,4 @@
-[2, 4]
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError:
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_int_to_bytes.py.exp	2026-03-28 15:57:18.916027298 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_int_to_bytes.py.out	2026-03-28 15:57:18.916027298 +0000
@@ -1,6 +1 @@
-CPYTHON3 CRASH:
-Traceback (most recent call last):
-  File "/app/src/lib/micropython/tests/cpydiff/types_int_to_bytes.py", line 16, in <module>
-    print(x.to_bytes(1, "big"))
-          ^^^^^^^^^^^^^^^^^^^^
-OverflowError: can't convert negative int to unsigned
+b'\xff'
--- /app/src/lib/micropython/tests/results/cpydiff_core_function_moduleattr.py.exp	2026-03-28 15:57:16.504027325 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_function_moduleattr.py.out	2026-03-28 15:57:16.504027325 +0000
@@ -1 +1,4 @@
-__main__
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+AttributeError: 'function' object has no attribute '__module__'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_oserror_errnomap.py.exp	2026-03-28 15:57:19.232027294 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_oserror_errnomap.py.out	2026-03-28 15:57:19.232027294 +0000
@@ -1,22 +1,4 @@
-EPERM = PermissionError
-ENOENT = FileNotFoundError
-EIO = OSError
-EBADF = OSError
-EAGAIN = BlockingIOError
-ENOMEM = OSError
-EACCES = PermissionError
-EEXIST = FileExistsError
-ENODEV = OSError
-EISDIR = IsADirectoryError
-EINVAL = OSError
-ENOTSUP = OSError
-EADDRINUSE = OSError
-ECONNABORTED = ConnectionAbortedError
-ECONNRESET = ConnectionResetError
-ENOBUFS = OSError
-ENOTCONN = OSError
-ETIMEDOUT = TimeoutError
-ECONNREFUSED = ConnectionRefusedError
-EHOSTUNREACH = OSError
-EALREADY = BlockingIOError
-EINPROGRESS = BlockingIOError
+Traceback (most recent call last):
+  File "<stdin>"
+SyntaxError: invalid syntax
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_function_userattr.py.exp	2026-03-28 15:57:16.556027325 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_function_userattr.py.out	2026-03-28 15:57:16.556027325 +0000
@@ -1 +1,4 @@
-0
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+AttributeError: 'function' object has no attribute 'x'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_class_initsubclass_autoclassmethod.py.exp	2026-03-28 15:57:15.680027334 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_class_initsubclass_autoclassmethod.py.out	2026-03-28 15:57:15.680027334 +0000
@@ -1,2 +1,3 @@
+function
 method
-method
+FAIL
--- /app/src/lib/micropython/tests/results/cpydiff_core_exception_construction.py.exp	2026-03-28 15:57:16.248027328 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_exception_construction.py.out	2026-03-28 15:57:16.248027328 +0000
@@ -1,2 +1,2 @@
-C
+TypeError
 C1
--- /app/src/lib/micropython/tests/results/cpydiff_modules_sys_stdassign.py.exp	2026-03-28 15:57:17.756027311 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_sys_stdassign.py.out	2026-03-28 15:57:17.756027311 +0000
@@ -1 +1,4 @@
-None
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+AttributeError: 'module' object has no attribute 'stdin'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_int_bit_length.py.exp	2026-03-28 15:57:18.796027299 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_int_bit_length.py.out	2026-03-28 15:57:18.796027299 +0000
@@ -1 +1,4 @@
-255 is 8 bits long.
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+AttributeError: 'int' object has no attribute 'bit_length'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_import_split_ns_pkgs.py.exp	2026-03-28 15:57:16.744027322 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_import_split_ns_pkgs.py.out	2026-03-28 15:57:16.744027322 +0000
@@ -1,5 +1,4 @@
-CPYTHON3 CRASH:
 Traceback (most recent call last):
-  File "/app/src/lib/micropython/tests/cpydiff/core_import_split_ns_pkgs.py", line 13, in <module>
-    import subpkg.foo
-ModuleNotFoundError: No module named 'subpkg'
+  File "<stdin>", in <module>
+IndexError: list index out of range
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/basics_io_iobase.py.exp	2026-03-28 15:56:41.212027722 +0000
+++ /app/src/lib/micropython/tests/results/basics_io_iobase.py.out	2026-03-28 15:56:41.212027722 +0000
@@ -1,2 +1,4 @@
-write 4
-write 1
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+TypeError: extra keyword arguments given
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_bytes_keywords.py.exp	2026-03-28 15:57:18.264027305 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_bytes_keywords.py.out	2026-03-28 15:57:18.264027305 +0000
@@ -1 +1,4 @@
-b'abc'
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError: keyword argument(s) not implemented - use normal args instead
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_bytearray_sliceassign.py.exp	2026-03-28 15:57:18.160027306 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_bytearray_sliceassign.py.out	2026-03-28 15:57:18.160027306 +0000
@@ -1 +1,4 @@
-bytearray(b'\x01\x02\x00\x00\x00')
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError: array/bytes required on right side
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_range_limits.py.exp	2026-03-28 15:57:19.304027294 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_range_limits.py.out	2026-03-28 15:57:19.304027294 +0000
@@ -1,3 +1,4 @@
-range(-9223372036854775808, 0)
-OverflowError
-2
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+ImportError: can't import name maxsize
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_module_array_comparison.py.exp	2026-03-28 15:57:16.924027320 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_module_array_comparison.py.out	2026-03-28 15:57:16.924027320 +0000
@@ -0,0 +1,4 @@
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError:
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_syntax_spaces.py.exp	2026-03-28 15:57:18.032027308 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_syntax_spaces.py.out	2026-03-28 15:57:18.032027308 +0000
@@ -1,8 +1,4 @@
-<string>:1: SyntaxWarning: invalid decimal literal
-<string>:1: SyntaxWarning: invalid decimal literal
-<string>:1: SyntaxWarning: invalid decimal literal
-<string>:1: SyntaxWarning: invalid decimal literal
-0
-1
-1
-b'\x01'
+Should have worked
+Should have worked
+Should have worked
+Should have worked
--- /app/src/lib/micropython/tests/results/cpydiff_core_import_path.py.exp	2026-03-28 15:57:16.676027323 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_import_path.py.out	2026-03-28 15:57:16.676027323 +0000
@@ -1 +1,4 @@
-['/app/src/lib/micropython/tests/cpydiff/modules']
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+ImportError: no module named 'modules'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_generator_noexit.py.exp	2026-03-28 15:57:16.620027324 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_generator_noexit.py.out	2026-03-28 15:57:16.620027324 +0000
@@ -2,4 +2,3 @@
 1
 2
 3
-Exit
--- /app/src/lib/micropython/tests/results/cpydiff_types_tuple_subscrstep.py.exp	2026-03-28 15:57:19.744027289 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_tuple_subscrstep.py.out	2026-03-28 15:57:19.744027289 +0000
@@ -1 +1,4 @@
-(1, 3)
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError: only slices with step=1 (aka None) are supported
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_class_name_mangling.py.exp	2026-03-28 15:57:15.948027331 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_class_name_mangling.py.out	2026-03-28 15:57:15.948027331 +0000
@@ -1,9 +1,2 @@
-CPYTHON3 CRASH:
 Example String to print.
-Traceback (most recent call last):
-  File "/app/src/lib/micropython/tests/cpydiff/core_class_name_mangling.py", line 26, in <module>
-    class_item.do_print()
-  File "/app/src/lib/micropython/tests/cpydiff/core_class_name_mangling.py", line 18, in do_print
-    __print_string(self.string)
-    ^^^^^^^^^^^^^^
-NameError: name '_Foo__print_string' is not defined. Did you mean: '__print_string'?
+Example String to print.
--- /app/src/lib/micropython/tests/results/cpydiff_modules_struct_manyargs.py.exp	2026-03-28 15:57:17.656027312 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_struct_manyargs.py.out	2026-03-28 15:57:17.656027312 +0000
@@ -1 +1,2 @@
-struct.error
+b'\x01\x02'
+Should not get here
--- /app/src/lib/micropython/tests/results/cpydiff_core_fstring_concat.py.exp	2026-03-28 15:57:16.300027327 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_fstring_concat.py.out	2026-03-28 15:57:16.300027327 +0000
@@ -1,4 +1,4 @@
-aa1
-1ab
-a{}a1
-1a{}b
+Traceback (most recent call last):
+  File "<stdin>"
+SyntaxError: invalid syntax
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_exception_attrs.py.exp	2026-03-28 15:57:18.472027303 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_exception_attrs.py.out	2026-03-28 15:57:18.472027303 +0000
@@ -1,6 +1,2 @@
-CPYTHON3 CRASH:
-Traceback (most recent call last):
-  File "/app/src/lib/micropython/tests/cpydiff/types_exception_attrs.py", line 9, in <module>
-    print(e.value)
-          ^^^^^^^
-AttributeError: 'Exception' object has no attribute 'value'
+1
+1
--- /app/src/lib/micropython/tests/results/cpydiff_modules_struct_fewargs.py.exp	2026-03-28 15:57:17.604027313 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_struct_fewargs.py.out	2026-03-28 15:57:17.604027313 +0000
@@ -1 +1,2 @@
-struct.error
+b'\x01\x00'
+Should not get here
--- /app/src/lib/micropython/tests/results/cpydiff_core_locals_eval.py.exp	2026-03-28 15:57:16.860027321 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_locals_eval.py.out	2026-03-28 15:57:16.860027321 +0000
@@ -1,2 +1,2 @@
 2
-2
+1
--- /app/src/lib/micropython/tests/results/cpydiff_modules_array_subscrstep.py.exp	2026-03-28 15:57:17.168027318 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_array_subscrstep.py.out	2026-03-28 15:57:17.168027318 +0000
@@ -1 +1,4 @@
-array('b')
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError: only slices with step=1 (aka None) are supported
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_locals.py.exp	2026-03-28 15:57:16.796027322 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_locals.py.out	2026-03-28 15:57:16.796027322 +0000
@@ -1 +1 @@
-{'val': 2}
+{'test': <function test at 0x20000840>, '__name__': '__main__', '__file__': '<stdin>'}
--- /app/src/lib/micropython/tests/results/cpydiff_types_bytes_subscrstep.py.exp	2026-03-28 15:57:18.316027305 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_bytes_subscrstep.py.out	2026-03-28 15:57:18.316027305 +0000
@@ -1 +1,4 @@
-b'13'
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError: only slices with step=1 (aka None) are supported
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_modules_array_containment.py.exp	2026-03-28 15:57:17.040027319 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_array_containment.py.out	2026-03-28 15:57:17.040027319 +0000
@@ -1 +1,4 @@
-False
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError:
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_bytes_format.py.exp	2026-03-28 15:57:18.216027306 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_bytes_format.py.out	2026-03-28 15:57:18.216027306 +0000
@@ -1,6 +1 @@
-CPYTHON3 CRASH:
-Traceback (most recent call last):
-  File "/app/src/lib/micropython/tests/cpydiff/types_bytes_format.py", line 8, in <module>
-    print(b"{}".format(1))
-          ^^^^^^^^^^^^
-AttributeError: 'bytes' object has no attribute 'format'
+b'1'
--- /app/src/lib/micropython/tests/results/cpydiff_syntax_literal_underscore.py.exp	2026-03-28 15:57:17.960027309 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_syntax_literal_underscore.py.out	2026-03-28 15:57:17.960027309 +0000
@@ -1,2 +1,2 @@
-Should not work
-Should not work
+11
+1
--- /app/src/lib/micropython/tests/results/cpydiff_types_str_keywords.py.exp	2026-03-28 15:57:19.544027291 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_str_keywords.py.out	2026-03-28 15:57:19.548027291 +0000
@@ -1 +1,4 @@
-abc
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError: keyword argument(s) not implemented - use normal args instead
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_exception_subclassinit.py.exp	2026-03-28 15:57:18.692027300 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_exception_subclassinit.py.out	2026-03-28 15:57:18.692027300 +0000
@@ -0,0 +1,5 @@
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+  File "<stdin>", in __init__
+AttributeError: type object 'Exception' has no attribute '__init__'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_modules_os_environ.py.exp	2026-03-28 15:57:17.364027315 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_os_environ.py.out	2026-03-28 15:57:17.364027315 +0000
@@ -1,2 +1,4 @@
-None
-VALUE
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+ImportError: no module named 'os'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_str_formatsubscr.py.exp	2026-03-28 15:57:19.488027292 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_str_formatsubscr.py.out	2026-03-28 15:57:19.488027292 +0000
@@ -1 +1,4 @@
-1
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError: attributes not supported
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_dict_keys_set.py.exp	2026-03-28 15:57:18.420027304 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_dict_keys_set.py.out	2026-03-28 15:57:18.420027304 +0000
@@ -1 +1,4 @@
-{1}
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+TypeError: unsupported types for : 'dict_view', 'set'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_modules_errno_enotsup.py.exp	2026-03-28 15:57:17.220027317 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_errno_enotsup.py.out	2026-03-28 15:57:17.220027317 +0000
@@ -1 +1,4 @@
-errno.errorcode[errno.EOPNOTSUPP]=ENOTSUP
+Traceback (most recent call last):
+  File "<stdin>"
+SyntaxError: invalid syntax
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_exception_chaining.py.exp	2026-03-28 15:57:18.520027302 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_exception_chaining.py.out	2026-03-28 15:57:18.520027302 +0000
@@ -1,12 +1,4 @@
-CPYTHON3 CRASH:
 Traceback (most recent call last):
-  File "/app/src/lib/micropython/tests/cpydiff/types_exception_chaining.py", line 9, in <module>
-    raise TypeError
-TypeError
-
-During handling of the above exception, another exception occurred:
-
-Traceback (most recent call last):
-  File "/app/src/lib/micropython/tests/cpydiff/types_exception_chaining.py", line 11, in <module>
-    raise ValueError
-ValueError
+  File "<stdin>", in <module>
+ValueError:
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_class_initsubclass_kwargs.py.exp	2026-03-28 15:57:15.744027334 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_class_initsubclass_kwargs.py.out	2026-03-28 15:57:15.744027334 +0000
@@ -1 +1,4 @@
-Base.__init_subclass__(A, arg='arg', kwargs={})
+Traceback (most recent call last):
+  File "<stdin>"
+SyntaxError: invalid syntax
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_class_mro.py.exp	2026-03-28 15:57:15.876027332 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_class_mro.py.out	2026-03-28 15:57:15.876027332 +0000
@@ -1 +1 @@
-Foo
+(1, 2, 3)
--- /app/src/lib/micropython/tests/results/cpydiff_core_fstring_parser.py.exp	2026-03-28 15:57:16.352027327 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_fstring_parser.py.out	2026-03-28 15:57:16.352027327 +0000
@@ -1,2 +1,4 @@
-hello { world
-hello ] world
+Traceback (most recent call last):
+  File "<stdin>"
+SyntaxError: invalid syntax
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_str_subscrstep.py.exp	2026-03-28 15:57:19.696027289 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_str_subscrstep.py.out	2026-03-28 15:57:19.696027289 +0000
@@ -1 +1,4 @@
-acegi
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError: only slices with step=1 (aka None) are supported
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_class_initsubclass_super.py.exp	2026-03-28 15:57:15.812027333 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_class_initsubclass_super.py.out	2026-03-28 15:57:15.812027333 +0000
@@ -0,0 +1,5 @@
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+  File "<stdin>", in __init_subclass__
+AttributeError: 'super' object has no attribute '__init_subclass__'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_modules_random_randint.py.exp	2026-03-28 15:57:17.540027313 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_random_randint.py.out	2026-03-28 15:57:17.540027313 +0000
@@ -1 +1,4 @@
-x=340282366920938463463374607431768211456
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+ImportError: no module named 'random'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_memoryview_invalid.py.exp	2026-03-28 15:57:19.156027295 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_memoryview_invalid.py.out	2026-03-28 15:57:19.156027295 +0000
@@ -1,5 +1 @@
-CPYTHON3 CRASH:
-Traceback (most recent call last):
-  File "/app/src/lib/micropython/tests/cpydiff/types_memoryview_invalid.py", line 12, in <module>
-    b.extend(b"hijklmnop")
-BufferError: Existing exports of data: object cannot be re-sized
+bytearray(b'abcdefghijklmnop') b'abcdefg'
--- /app/src/lib/micropython/tests/results/cpydiff_modules_random_getrandbits.py.exp	2026-03-28 15:57:17.480027314 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_random_getrandbits.py.out	2026-03-28 15:57:17.480027314 +0000
@@ -1 +1,4 @@
-7183054857758210777
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+ImportError: no module named 'random'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_exception_instancevar.py.exp	2026-03-28 15:57:18.576027302 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_exception_instancevar.py.out	2026-03-28 15:57:18.576027302 +0000
@@ -1 +1,4 @@
-0
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+AttributeError: 'Exception' object has no attribute 'x'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_modules_os_getenv.py.exp	2026-03-28 15:57:17.416027315 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_os_getenv.py.out	2026-03-28 15:57:17.416027315 +0000
@@ -1,2 +1,4 @@
-None
-None
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+ImportError: no module named 'os'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_modules_json_nonserializable.py.exp	2026-03-28 15:57:17.292027316 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_json_nonserializable.py.out	2026-03-28 15:57:17.292027316 +0000
@@ -1 +1,4 @@
-TypeError
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+ImportError: no module named 'json'
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_syntax_assign_expr.py.exp	2026-03-28 15:57:17.892027309 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_syntax_assign_expr.py.out	2026-03-28 15:57:17.892027309 +0000
@@ -1,5 +1 @@
-CPYTHON3 CRASH:
-  File "/app/src/lib/micropython/tests/cpydiff/syntax_assign_expr.py", line 8
-    print([[(j := i) for i in range(2)] for j in range(2)])
-             ^
-SyntaxError: assignment expression cannot rebind comprehension iteration variable 'j'
+[[0, 1], [0, 1]]
--- /app/src/lib/micropython/tests/results/cpydiff_types_complex_parser.py.exp	2026-03-28 15:57:18.368027304 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_complex_parser.py.out	2026-03-28 15:57:18.368027304 +0000
@@ -1 +1,4 @@
-ValueError
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NameError: name 'complex' isn't defined
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_str_formatsep_float.py.exp	2026-03-28 15:57:19.436027292 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_str_formatsep_float.py.out	2026-03-28 15:57:19.436027292 +0000
@@ -1,4 +1,4 @@
-3,141.159000
-3_141.159000
-0,003,141.16
-0_003_141.16
+3141.159000
+3141.159000
+000,3141.16
+0_003141.16
--- /app/src/lib/micropython/tests/results/cpydiff_module_array_constructor.py.exp	2026-03-28 15:57:16.984027320 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_module_array_constructor.py.out	2026-03-28 15:57:16.984027320 +0000
@@ -1,6 +1 @@
-CPYTHON3 CRASH:
-Traceback (most recent call last):
-  File "/app/src/lib/micropython/tests/cpydiff/module_array_constructor.py", line 10, in <module>
-    a = array.array("b", [257])
-        ^^^^^^^^^^^^^^^^^^^^^^^
-OverflowError: signed char is greater than maximum
+array('b', [1])
--- /app/src/lib/micropython/tests/results/cpydiff_syntax_unicode_nameesc.py.exp	2026-03-28 15:57:18.100027307 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_syntax_unicode_nameesc.py.out	2026-03-28 15:57:18.100027307 +0000
@@ -1 +1,2 @@
-a
+NotImplementedError: unicode name escapes
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_list_store_noniter.py.exp	2026-03-28 15:57:19.028027297 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_list_store_noniter.py.out	2026-03-28 15:57:19.028027297 +0000
@@ -1 +1,4 @@
-[0, 1, 2, 3, 20]
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+TypeError: object 'range' isn't a tuple or list
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_class_super_init.py.exp	2026-03-28 15:57:16.032027330 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_class_super_init.py.out	2026-03-28 15:57:16.032027330 +0000
@@ -1,2 +1,2 @@
-OK
+AttributeError
 OK
--- /app/src/lib/micropython/tests/results/cpydiff_types_list_store_subscrstep.py.exp	2026-03-28 15:57:19.088027296 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_list_store_subscrstep.py.out	2026-03-28 15:57:19.088027296 +0000
@@ -1 +1,4 @@
-[5, 2, 6, 4]
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError:
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_function_argcount.py.exp	2026-03-28 15:57:16.452027326 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_function_argcount.py.out	2026-03-28 15:57:16.452027326 +0000
@@ -1 +1 @@
-list.append() takes exactly one argument (0 given)
+function takes 2 positional arguments but 1 were given
--- /app/src/lib/micropython/tests/results/cpydiff_types_str_rsplitnone.py.exp	2026-03-28 15:57:19.648027290 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_str_rsplitnone.py.out	2026-03-28 15:57:19.648027290 +0000
@@ -1 +1,4 @@
-['a a', 'a']
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+NotImplementedError: rsplit(None,n)
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_core_class_delnotimpl.py.exp	2026-03-28 15:57:15.556027336 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_core_class_delnotimpl.py.out	2026-03-28 15:57:15.556027336 +0000
@@ -1 +0,0 @@
-__del__
--- /app/src/lib/micropython/tests/results/cpydiff_modules_array_deletion.py.exp	2026-03-28 15:57:17.104027318 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_modules_array_deletion.py.out	2026-03-28 15:57:17.104027318 +0000
@@ -1 +1,4 @@
-array('b', [1, 3])
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+TypeError: 'array' object doesn't support item deletion
+CRASH
\ No newline at end of file
--- /app/src/lib/micropython/tests/results/cpydiff_types_int_subclassconv.py.exp	2026-03-28 15:57:18.860027299 +0000
+++ /app/src/lib/micropython/tests/results/cpydiff_types_int_subclassconv.py.out	2026-03-28 15:57:18.860027299 +0000
@@ -1 +1,5 @@
-84
+Traceback (most recent call last):
+  File "<stdin>", in <module>
+  File "<stdin>", in <lambda>
+TypeError: unsupported types for __add__: 'int', 'A'
+CRASH
\ No newline at end of file

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_struct_whitespace_in_format.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_float_implicit_conversion.py

FAILURE /app/src/lib/micropython/tests/results/basics_int_big1.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_str_formatsep.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_syntax_arg_unpacking.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_fstring_repr.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_class_supermultiple.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_exception_loops.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_str_ljust_rjust.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_class_initsubclass.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_class_superproperty.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_list_delete_subscrstep.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_int_to_bytes.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_function_moduleattr.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_oserror_errnomap.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_function_userattr.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_class_initsubclass_autoclassmethod.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_exception_construction.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_sys_stdassign.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_int_bit_length.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_import_split_ns_pkgs.py

FAILURE /app/src/lib/micropython/tests/results/basics_io_iobase.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_bytes_keywords.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_bytearray_sliceassign.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_range_limits.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_module_array_comparison.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_syntax_spaces.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_import_path.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_generator_noexit.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_tuple_subscrstep.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_class_name_mangling.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_struct_manyargs.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_fstring_concat.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_exception_attrs.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_struct_fewargs.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_locals_eval.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_array_subscrstep.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_locals.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_bytes_subscrstep.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_array_containment.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_bytes_format.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_syntax_literal_underscore.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_str_keywords.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_exception_subclassinit.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_os_environ.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_str_formatsubscr.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_dict_keys_set.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_errno_enotsup.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_exception_chaining.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_class_initsubclass_kwargs.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_class_mro.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_fstring_parser.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_str_subscrstep.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_class_initsubclass_super.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_random_randint.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_memoryview_invalid.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_random_getrandbits.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_exception_instancevar.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_os_getenv.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_json_nonserializable.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_syntax_assign_expr.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_complex_parser.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_str_formatsep_float.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_module_array_constructor.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_syntax_unicode_nameesc.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_list_store_noniter.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_class_super_init.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_list_store_subscrstep.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_function_argcount.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_str_rsplitnone.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_core_class_delnotimpl.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_modules_array_deletion.py

FAILURE /app/src/lib/micropython/tests/results/cpydiff_types_int_subclassconv.py

```
