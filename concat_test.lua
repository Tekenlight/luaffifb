local ffi = require('ffi');
local a = 'hello ';
local b = ffi.new("uint8_t", 1);
local s = ffi.new("uint16_t", 2);
local i = ffi.new("uint32_t", 3);
local l = ffi.new("uint64_t", 4);

assert(a .. b .. s .. i .. l == 'hello 1234');
assert(b .. s .. i .. l .. a == '1234hello ');
assert(b .. s .. a .. i .. l == '12hello 34');

local bb = ffi.new("_Bool", true);
assert(bb .. b .. s .. a .. i .. l == 'true12hello 34');
assert(b .. s .. a .. i .. l .. bb == '12hello 34true')
assert(b .. s .. a .. bb .. i .. l == '12hello true34');

print("concat_test PASSED");
