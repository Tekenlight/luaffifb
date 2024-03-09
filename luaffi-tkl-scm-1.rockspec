package = "luaffi-tkl"
version = "scm-1"

source = {
   url = "git://github.com/Tekenlight/luaffifb.git",
}

description = {
   summary = "FFI library for calling C functions from lua",
   detailed = [[
   ]],
   homepage = "https://github.com/Tekenlight/luaffifb",
   license = "BSD"
}

dependencies = {
   "lua >= 5.1",
}

build = {
   type = "builtin",
   modules = {
      ['ffi'] = {
         incdirs = {
            "dynasm"
         },
         sources = {
            "call.c", "ctype.c", "ffi.c", "parser.c",
         }
      },
      ['ffi_test.libtest'] = 'test.c',
      ['ffi_test.test'] = 'test.lua',
	  bit = "bit.lua",
   }
}
