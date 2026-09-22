**luaffi-tkl is a maintained fork of luaffifb with additional functionality
for embedding and interoperability with native Lua applications.**

About
-----
This is a library for calling C function and manipulating C types from lua. It
is designed to be interface compatible with the FFI library in LuaJIT (see
http://luajit.org/ext_ffi.html). It can parse C function declarations and
struct definitions that have been directly copied out of C header files and
into lua source as a string.

This is a fork of https://github.com/jmckaskill/luaffi

Source
------
https://github.com/facebook/luaffifb

Platforms
---------
Currently supported:
- Linux x86/x64
- Linux ARM Aarch64
- OS X x86/x64
- OS X M1 (ARM64)

Runs with Lua 5.1, 5.2, and 5.3

Build
-----
In a terminal:

```bash
git clone https://github.com/Tekenlight/luaffifb
cd luaffifb
luarocks make
```

Documentation
-------------
This library is designed to be source compatible with LuaJIT's FFI extension. The documentation at http://luajit.org/ext_ffi.html describes the API and semantics.

Pointer Comparison
------------
Use `ffi.NULL` instead of `nil` when checking for `NULL` pointers.
```lua
  ffi.new('void *', 0) == ffi.NULL -- true
```

Known Issues
------------
- Comparing a ctype pointer to `nil` doesn't work the same as in LuaJIT (see above).
  This is unfixable with the current metamethod semantics.
- Constant expressions can't handle non integer intermediate values (eg
  offsetof won't work because it manipulates pointers)
- Not all metamethods work with Lua 5.1 (eg char\* + number). This is due to
  the way metamethods are looked up with mixed types in Lua 5.1. If you need
this upgrade to Lua 5.2 or use boxed numbers (uint64\_t and uintptr\_t).

How it works
------------
Types are represented by a struct ctype structure and an associated user value
table. The table is shared between all related types for structs, unions, and
functions. It's members have the types of struct members, function argument
types, etc. The struct ctype structure then contains the modifications from
the base type (eg number of pointers, array size, etc).

Types are pushed into lua as a userdata containing the struct ctype with a
user value (or fenv in 5.1) set to the shared type table.

Boxed cdata types are pushed into lua as a userdata containing the struct
cdata structure (which contains the struct ctype of the data as its header)
followed by the boxed data.

The functions in `ffi.C` provide the `cdata` and `ctype` metatables and ffi.\*
functions which manipulate these two types.

C functions (and function pointers) are pushed into lua as a lua c function
with the function pointer cdata as the first upvalue. The actual code is JITed
using dynasm (see call\_x86.dasc). The JITed code does the following in order:

1. Calls the needed unpack functions in `ffi.C` placing each argument on the HW stack
2. Updates `errno`
3. Performs the C call
4. Retrieves `errno`
5. Pushes the result back into lua from the HW register or stack


Extensions in this fork
-----------------------

In addition to the original luaffifb functionality, this fork includes:

- **Signed bitfield support**: C signed bitfields are supported, including
  correct sign extension when reading bitfield values. Signed and unsigned
  64-bit bitfields retain their 64-bit cdata representation.

- **User hook bridge**: Native code embedding this library can register hooks
  that create and interact with FFI values through the active Lua/FFI state.
  This allows native extensions to return FFI typed values directly without
  requiring the Lua layer to recreate them.

  
Usage with other lua frameworks
-------------------------------
This is not a comprehensive method that covers all other lua frameworks. It is more an
assimilation of learnings gathered to make those frameworks with this implementation
if lua ffi.

1. **[busted](https://github.com/lunarmodules/busted)**: The testing tool detects only LuaJIT ffi and not this ffi. When running with Lua5.2, 5.3 etc. it results in multiple free errors if this implementation is used in the test cases (via require). [Ref](https://github.com/Tekenlight/luaffifb/issues/5).  A helper script busted\_ref/detect\_ffi.lua has been provided in order to circumvent this. This helper gets installed along with *luarocks install ...* in the path *<LUA_PATH ...>/busted/detect_ffi.lua*. This helper can be used along with *busted* while using this implementation of ffi, in the following manner.
  
```
busted --helper=< path ... >/detect_ffi.lua --lua=lua5.3 test1.lua test2.lua
```

