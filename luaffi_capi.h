#ifndef LUAFFI_CAPI_H
#define LUAFFI_CAPI_H

#include <stdint.h>
#include <stddef.h>

#include <lua.h>

#ifdef __cplusplus
extern "C" {
#endif

#define LUAFFI_CAPI_VERSION 1

typedef struct luaffi_capi_v1 {

    uint32_t version;
    uint32_t size;

    /*
     * Each function pushes exactly one Lua value onto L.
     *
     * For the integer/float variants the pushed value is
     * LuaFFI cdata owned by Lua's GC.
     */

    void (*push_int16)(
        lua_State *L,
        int16_t value
    );

    void (*push_uint16)(
        lua_State *L,
        uint16_t value
    );

    void (*push_int32)(
        lua_State *L,
        int32_t value
    );

    void (*push_uint32)(
        lua_State *L,
        uint32_t value
    );

    void (*push_int64)(
        lua_State *L,
        int64_t value
    );

    void (*push_uint64)(
        lua_State *L,
        uint64_t value
    );

    void (*push_float)(
        lua_State *L,
        float value
    );

    /*
     * Push the same kind of cdata represented by ffi.NULL.
     */
    void (*push_null)(
        lua_State *L
    );

} luaffi_capi_v1;

#ifdef __cplusplus
}
#endif

#endif
