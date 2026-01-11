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

#ifndef SWIFT_X86_SHIM_H
#define SWIFT_X86_SHIM_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// Symbol Versioning Rule:
// All symbols use _v1 suffix. Symbols are never removed, only superseded.

// CPUID - CPU Identification
// Returns registers in out parameters. Returns false on non-x86.
bool swift_x86_identification_query_v1(
    unsigned int leaf,
    unsigned int* eax,
    unsigned int* ebx,
    unsigned int* ecx,
    unsigned int* edx
);

bool swift_x86_identification_query_subleaf_v1(
    unsigned int leaf,
    unsigned int subleaf,
    unsigned int* eax,
    unsigned int* ebx,
    unsigned int* ecx,
    unsigned int* edx
);

// RDRAND - Hardware Random Number Generator
// Returns true if random number was generated successfully
bool swift_x86_random_next_v1(unsigned long long* value);

// RDSEED - Hardware Random Seed Generator
// Returns true if seed was generated successfully
bool swift_x86_random_seed_v1(unsigned long long* value);

// RDTSCP - Serialized Timestamp Counter
// Returns timestamp and processor ID
unsigned long long swift_x86_timestamp_serialized_v1(unsigned int* processor_id);

#ifdef __cplusplus
}
#endif

#endif // SWIFT_X86_SHIM_H
