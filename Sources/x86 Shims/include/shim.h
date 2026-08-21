#ifndef SWIFT_X86_SHIM_H
#define SWIFT_X86_SHIM_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

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

bool swift_x86_random_next_v1(unsigned long long* value);

bool swift_x86_random_seed_v1(unsigned long long* value);

unsigned long long swift_x86_timestamp_serialized_v1(unsigned int* processor_id);

#ifdef __cplusplus
}
#endif

#endif
