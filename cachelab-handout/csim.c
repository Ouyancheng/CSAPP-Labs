#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <limits.h>
#include <getopt.h>
#include "cachelab.h"
struct cache_entry {
	unsigned long tag;
	unsigned long last_used;
};
void print_help() {
	printf(
		"Usage: ./csim-ref [-hv] -s <num> -E <num> -b <num> -t <file>\n"
		"Options:\n"
		"  -h         Print this help message.\n"
		"  -v         Optional verbose flag.\n"
		"  -s <num>   Number of set index bits.\n"
		"  -E <num>   Number of lines per set.\n"
		"  -b <num>   Number of block offset bits.\n"
		"  -t <file>  Trace file.\n"
		"\n"
		"Examples:\n"
		"  linux>  ./csim-ref -s 4 -E 1 -b 4 -t traces/yi.trace\n"
		"  linux>  ./csim-ref -v -s 8 -E 2 -b 4 -t traces/yi.trace\n"
	);
}
bool judge_hit(struct cache_entry *cache, 
	unsigned long address, 
	unsigned long offset_bits, 
	unsigned long index_bits, 
	unsigned long associativity,
	unsigned long current_time);
bool replace_entry(struct cache_entry *cache, 
	unsigned long address, 
	unsigned long offset_bits, 
	unsigned long index_bits, 
	unsigned long associativity, 
	unsigned long current_time);
int main(int argc, char ** const argv) {
	char option;
	char *trace_file_name;
	FILE *trace_file;
	bool verbose_flag = false; 
	unsigned long index_bits = 0;
	unsigned long associativity = 0;
	unsigned long offset_bits = 0;
	while ((option = getopt(argc, argv, "hvs:E:b:t:")) != -1) {
		switch (option) {
		case 'h': 
			print_help();
			return 0;
		case 'v': 
			verbose_flag = true;
			break;
		case 's': 
			index_bits = (unsigned)atol(optarg);
			break;
		case 'E': 
			associativity = (unsigned)atol(optarg);
			break;
		case 'b': 
			offset_bits = (unsigned)atol(optarg);
			break;
		case 't': 
			trace_file_name = optarg;
			break;
		default: 
			print_help();
			return 0;
		}
	}

	struct cache_entry *cache = (struct cache_entry *)calloc(associativity * (1 << index_bits), sizeof(struct cache_entry));

	trace_file = fopen(trace_file_name, "r");
	char operation; 
	unsigned long address;
	unsigned long byte_offset;

	unsigned long num_hits = 0;
	unsigned long num_misses = 0;
	unsigned long num_evictions = 0; 

	unsigned long current_time = 0;

	while (fscanf(trace_file, "%c%lx,%lu\n", &operation, &address, &byte_offset) != EOF) {
		++current_time; 
		switch (operation) {
		case 'L': 
			if (judge_hit(cache, address, offset_bits, index_bits, associativity, current_time)) {
				++num_hits;
				if (verbose_flag)
					printf("%c %lx,%lu hit\n", operation, address, byte_offset);
			} else {
				++num_misses;
				if (verbose_flag) {
					printf("%c %lx,%lu miss", operation, address, byte_offset);
				}
				if (replace_entry(cache, address, offset_bits, index_bits, associativity, current_time)) {
					++num_evictions;
					if (verbose_flag)
						printf(" eviction");
				}
				if (verbose_flag) 
					printf("\n");
			}
			break;
		case 'S': 
			if (judge_hit(cache, address, offset_bits, index_bits, associativity, current_time)) {
				++num_hits;
				if (verbose_flag)
					printf("%c %lx,%lu hit\n", operation, address, byte_offset);
			} else {
				++num_misses;
				if (verbose_flag) {
					printf("%c %lx,%lu miss", operation, address, byte_offset);
				}
				if (replace_entry(cache, address, offset_bits, index_bits, associativity, current_time)) {
					++num_evictions;
					if (verbose_flag) 
						printf(" eviction");
				}
				if (verbose_flag) 
					printf("\n");
			}
			break;
		case 'M': 
			if (judge_hit(cache, address, offset_bits, index_bits, associativity, current_time)) {
				num_hits += 2;
				if (verbose_flag)
					printf("%c %lx,%lu hit hit\n", operation, address, byte_offset);
			} else {
				++num_misses;
				if (verbose_flag) {
					printf("%c %lx,%lu miss", operation, address, byte_offset);
				}
				if (replace_entry(cache, address, offset_bits, index_bits, associativity, current_time)) {
					++num_evictions;
					if (verbose_flag)
						printf(" eviction");
				}
				++num_hits;
				if (verbose_flag) 
					printf(" hit\n");
			}
			break;
		default: 
			break; 
		}
	}
	free(cache);
	printSummary(num_hits, num_misses, num_evictions);
	return 0;
}

bool judge_hit(struct cache_entry *cache, 
	unsigned long address, 
	unsigned long offset_bits, 
	unsigned long index_bits, 
	unsigned long associativity,
	unsigned long current_time) {
	unsigned long index_mask = (~(((long)0x8000000000000000) >> (63 - (index_bits + offset_bits)))) >> offset_bits; 
	struct cache_entry *i;
	for (i = &cache[((address >> offset_bits) & index_mask) * associativity]; 
		i < &cache[((address >> offset_bits) & index_mask) * associativity + associativity]; 
		++i) {
		if (i->tag == (address >> (offset_bits + index_bits)) && i->last_used != 0) {
			i->last_used = current_time;
			return true;
		}
	}
	return false;
}
bool replace_entry(struct cache_entry *cache, 
	unsigned long address, 
	unsigned long offset_bits, 
	unsigned long index_bits, 
	unsigned long associativity, 
	unsigned long current_time) {
	unsigned long index_mask = (~(((long)0x8000000000000000) >> (63 - (index_bits + offset_bits)))) >> offset_bits; 
	unsigned long oldest_time = UINT_MAX;
	struct cache_entry *oldest_entry = &cache[((address >> offset_bits) & index_mask) * associativity]; 
	struct cache_entry *i;
	bool eviction = false;
	for (i = oldest_entry; 
		i < &cache[((address >> offset_bits) & index_mask) * associativity + associativity]; 
		++i) {
		if (i->last_used < oldest_time) {
			oldest_time = i->last_used;
			oldest_entry = i;
		}
	}
	if (oldest_entry->last_used != 0) {
		eviction = true; 
	}
	oldest_entry->tag = (address >> (offset_bits + index_bits));
	oldest_entry->last_used = current_time; 
	return eviction;
}