// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-x86-primitives open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-x86-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

#include "include/shim.h"

// Architecture detection
#if defined(__x86_64__) || defined(__i386__) || defined(_M_X64) || defined(_M_IX86)
    #define SWIFT_X86 1
#endif

// Platform detection for intrinsics
#if defined(_MSC_VER)
    #include <intrin.h>
    #include <immintrin.h>
    #define SWIFT_MSVC 1
#elif defined(__GNUC__) || defined(__clang__)
    #if SWIFT_X86
        #include <cpuid.h>
        #include <x86intrin.h>
    #endif
#endif

// Per-function target-feature enablement for the MSVC/clang intrinsic path.
// `_rdrand{32,64}_step` / `_rdseed{32,64}_step` are always_inline intrinsics
// that require the `rdrnd` / `rdseed` target features; without them the compiler
// hard-errors when inlining into a caller compiled for a baseline CPU. This bites
// the Windows toolchain, which is clang targeting *-windows-msvc (so _MSC_VER is
// defined and the SWIFT_MSVC intrinsic path is taken) built for a generic
// baseline. The GNU inline-asm path (Linux/macOS x86) does not need the feature
// — inline asm is opaque to the feature check — so the attribute is harmless
// there. On non-x86 targets the macro expands to nothing (rdrnd/rdseed are x86
// features and the intrinsic bodies are already #if SWIFT_X86-guarded out).
// Runtime availability is the caller's concern (RDRAND/RDSEED ship on every
// x86-64 CPU since Ivy Bridge, 2012).
#if (defined(__GNUC__) || defined(__clang__)) && defined(SWIFT_X86)
    #define SWIFT_X86_TARGET(feat) __attribute__((target(feat)))
#else
    #define SWIFT_X86_TARGET(feat)
#endif

// ============================================================================
// CPUID - CPU Identification
// ============================================================================

bool swift_x86_identification_query_v1(
    unsigned int leaf,
    unsigned int* eax,
    unsigned int* ebx,
    unsigned int* ecx,
    unsigned int* edx
) {
#if SWIFT_X86
    #if defined(SWIFT_MSVC)
        int regs[4];
        __cpuid(regs, (int)leaf);
        *eax = (unsigned int)regs[0];
        *ebx = (unsigned int)regs[1];
        *ecx = (unsigned int)regs[2];
        *edx = (unsigned int)regs[3];
        return true;
    #else
        return __get_cpuid(leaf, eax, ebx, ecx, edx) != 0;
    #endif
#else
    (void)leaf;
    *eax = 0;
    *ebx = 0;
    *ecx = 0;
    *edx = 0;
    return false;
#endif
}

bool swift_x86_identification_query_subleaf_v1(
    unsigned int leaf,
    unsigned int subleaf,
    unsigned int* eax,
    unsigned int* ebx,
    unsigned int* ecx,
    unsigned int* edx
) {
#if SWIFT_X86
    #if defined(SWIFT_MSVC)
        int regs[4];
        __cpuidex(regs, (int)leaf, (int)subleaf);
        *eax = (unsigned int)regs[0];
        *ebx = (unsigned int)regs[1];
        *ecx = (unsigned int)regs[2];
        *edx = (unsigned int)regs[3];
        return true;
    #else
        return __get_cpuid_count(leaf, subleaf, eax, ebx, ecx, edx) != 0;
    #endif
#else
    (void)leaf;
    (void)subleaf;
    *eax = 0;
    *ebx = 0;
    *ecx = 0;
    *edx = 0;
    return false;
#endif
}

// ============================================================================
// RDRAND - Hardware Random Number Generator
// ============================================================================

SWIFT_X86_TARGET("rdrnd")
bool swift_x86_random_next_v1(unsigned long long* value) {
#if SWIFT_X86
    #if defined(__x86_64__) || defined(_M_X64)
        // 64-bit: use RDRAND for 64-bit value
        #if defined(SWIFT_MSVC)
            return _rdrand64_step(value) != 0;
        #else
            unsigned long long tmp;
            unsigned char ok;
            __asm__ __volatile__(
                "rdrand %0; setc %1"
                : "=r"(tmp), "=qm"(ok)
            );
            *value = tmp;
            return ok != 0;
        #endif
    #else
        // 32-bit: use two RDRAND calls
        #if defined(SWIFT_MSVC)
            unsigned int lo, hi;
            if (_rdrand32_step(&lo) == 0) return false;
            if (_rdrand32_step(&hi) == 0) return false;
            *value = ((unsigned long long)hi << 32) | lo;
            return true;
        #else
            unsigned int lo, hi;
            unsigned char ok;
            __asm__ __volatile__(
                "rdrand %0; setc %1"
                : "=r"(lo), "=qm"(ok)
            );
            if (!ok) return false;
            __asm__ __volatile__(
                "rdrand %0; setc %1"
                : "=r"(hi), "=qm"(ok)
            );
            if (!ok) return false;
            *value = ((unsigned long long)hi << 32) | lo;
            return true;
        #endif
    #endif
#else
    (void)value;
    return false;
#endif
}

// ============================================================================
// RDSEED - Hardware Random Seed Generator
// ============================================================================

SWIFT_X86_TARGET("rdseed")
bool swift_x86_random_seed_v1(unsigned long long* value) {
#if SWIFT_X86
    #if defined(__x86_64__) || defined(_M_X64)
        // 64-bit: use RDSEED for 64-bit value
        #if defined(SWIFT_MSVC)
            return _rdseed64_step(value) != 0;
        #else
            unsigned long long tmp;
            unsigned char ok;
            __asm__ __volatile__(
                "rdseed %0; setc %1"
                : "=r"(tmp), "=qm"(ok)
            );
            *value = tmp;
            return ok != 0;
        #endif
    #else
        // 32-bit: use two RDSEED calls
        #if defined(SWIFT_MSVC)
            unsigned int lo, hi;
            if (_rdseed32_step(&lo) == 0) return false;
            if (_rdseed32_step(&hi) == 0) return false;
            *value = ((unsigned long long)hi << 32) | lo;
            return true;
        #else
            unsigned int lo, hi;
            unsigned char ok;
            __asm__ __volatile__(
                "rdseed %0; setc %1"
                : "=r"(lo), "=qm"(ok)
            );
            if (!ok) return false;
            __asm__ __volatile__(
                "rdseed %0; setc %1"
                : "=r"(hi), "=qm"(ok)
            );
            if (!ok) return false;
            *value = ((unsigned long long)hi << 32) | lo;
            return true;
        #endif
    #endif
#else
    (void)value;
    return false;
#endif
}

// ============================================================================
// RDTSCP - Serialized Timestamp Counter
// ============================================================================

unsigned long long swift_x86_timestamp_serialized_v1(unsigned int* processor_id) {
#if SWIFT_X86
    #if defined(SWIFT_MSVC)
        return __rdtscp(processor_id);
    #else
        unsigned int lo, hi, aux;
        __asm__ __volatile__(
            "rdtscp"
            : "=a"(lo), "=d"(hi), "=c"(aux)
        );
        if (processor_id) {
            *processor_id = aux;
        }
        return ((unsigned long long)hi << 32) | lo;
    #endif
#else
    if (processor_id) {
        *processor_id = 0;
    }
    return 0;
#endif
}
