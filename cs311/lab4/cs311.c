#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define BYTES_PER_WORD 4

typedef struct {
    char valid;
    char dirty;
    uint32_t tag;
    uint32_t seq;
} CACHE_BLOCK;

typedef struct {
    CACHE_BLOCK *blocks;
} CACHE_SET;

typedef struct {
    uint16_t n_set;
    uint16_t n_block;
    uint16_t n_byte;

    uint16_t s_tag;
    uint16_t s_index;
    uint16_t s_offset;

    CACHE_SET *sets;
    uint32_t** data;
} CACHE;

CACHE cache;

int total_reads = 0;
int total_writes = 0;
int write_backs = 0;
int read_hits = 0;
int write_hits = 0;
int read_misses = 0;
int write_misses = 0;


/* Helper Functions - index, tag */
uint32_t get_index(uint32_t addr) {
    return addr << cache.s_tag >> cache.s_tag >> cache.s_offset;
}

uint32_t get_tag(uint32_t addr) {
    return addr >> cache.s_offset >> cache.s_index;
}

uint32_t clear_offset(uint32_t addr) {
    return addr >> cache.s_offset << cache.s_offset;
}

/* Core Functions - read, write */
void cache_read(uint32_t addr, uint32_t seq) {
    uint32_t index = get_index(addr);
    uint32_t tag = get_tag(addr);
    
    int i = 0;

    total_reads++;

    CACHE_SET *set = &cache.sets[index];
    for (i = 0; i < cache.n_block; i++) {
        CACHE_BLOCK *block = &set->blocks[i];
        if (block->valid && block->tag == tag) {
            read_hits++;
            block->seq = seq;
            return;
        }
    }

    read_misses++;
    
    int block_index = 0, seq_sm = 1 << 30;
    for (i = 0; i < cache.n_block; i++) {
        CACHE_BLOCK *block = &set->blocks[i];
        if (!block->valid) {
            block->valid = 1;
            block->dirty = 0;
            block->tag = tag;
            block->seq = seq;
            cache.data[index][i] = addr;
            return;
        }
        if (block->seq < seq_sm) {
            seq_sm = block->seq;
            block_index = i;
        }
    }

    if ((set->blocks[block_index]).dirty) {
        write_backs++;
        (set->blocks[block_index]).dirty = 0;
    }
    (set->blocks[block_index]).tag = tag;
    (set->blocks[block_index]).seq = seq;
    cache.data[index][block_index] = addr;
}

void cache_write(uint32_t addr, uint32_t seq) {
    uint32_t index = get_index(addr);
    uint32_t tag = get_tag(addr);
    
    int i = 0;

    total_writes++;

    CACHE_SET *set = &cache.sets[index];
    for (i = 0; i < cache.n_block; i++) {
        CACHE_BLOCK *block = &set->blocks[i];
        if (block->valid && block->tag == tag) {
            write_hits++;
            cache.data[index][i] = addr;
            block->seq = seq;
            block->dirty = 1;
            return;
        }
    }

    write_misses++;
    
    int block_index = 0, seq_sm = 1 << 30;
    for (i = 0; i < cache.n_block; i++) {
        CACHE_BLOCK *block = &set->blocks[i];
        if (!block->valid) {
            block->valid = 1;
            block->dirty = 1;
            block->tag = tag;
            block->seq = seq;
            cache.data[index][i] = addr;
            return;
        }
        if (block->seq < seq_sm) {
            seq_sm = block->seq;
            block_index = i;
        }
    }

    if ((set->blocks[block_index]).dirty) {
        write_backs++;
    }
    (set->blocks[block_index]).tag = tag;
    (set->blocks[block_index]).dirty = 1;
    (set->blocks[block_index]).seq = seq;
    cache.data[index][block_index] = addr;
}

/* Helper Functions - log2 */
int log2i(int c) {
    int x = 0;
    while (c >= 2) {
        x++;
        c/=2;
    }
    return x;
}

/* Helper Functions - Print */
void cdump(int capacity, int assoc, int blocksize){
	printf("Cache Configuration:\n");
    printf("-------------------------------------\n");
	printf("Capacity: %dB\n", capacity);
	printf("Associativity: %dway\n", assoc);
	printf("Block Size: %dB\n", blocksize);
	printf("\n");
}

void sdump(int total_reads, int total_writes, int write_backs,
	    int reads_hits, int write_hits, int reads_misses, int write_misses) {
	printf("Cache Stat:\n");
    printf("-------------------------------------\n");
	printf("Total reads: %d\n", total_reads);
	printf("Total writes: %d\n", total_writes);
	printf("Write-backs: %d\n", write_backs);
	printf("Read hits: %d\n", reads_hits);
	printf("Write hits: %d\n", write_hits);
	printf("Read misses: %d\n", reads_misses);
	printf("Write misses: %d\n", write_misses);
	printf("\n");
}

void xdump(int set, int way, uint32_t** cache)
{
	int i, j, k = 0;

	printf("Cache Content:\n");
    printf("-------------------------------------\n");
	for(i = 0; i < way; i++) {
		if(i == 0) {
			printf("    ");
		}
		printf("      WAY[%d]",i);
	}
	printf("\n");

	for(i = 0 ; i < set;i++) {
		printf("SET[%d]:   ", i);
		for(j = 0; j < way; j++) {
			if(k != 0 && j == 0) {
				printf("          ");
			}
			printf("0x%08x  ", cache[i][j]);
		}
		printf("\n");
	}
	printf("\n");
}

int main(int argc, char *argv[]) {
	int i, j;
    int capacity = 256;
	int way = 4;
	int blocksize = 8;

    int count = 0;
    char** tokens;

    int conf_set = 0;
    int dump_set = 0;

    if (argc < 2) {
        printf("Error: usages: %s [-c cap:assoc:bsize] [-x] input_trace\n", argv[0]);
        exit(1);
    }

    while (count != argc - 1) {
        if (strcmp(argv[count], "-c") == 0) {
            sscanf(argv[++count], "%d:%d:%d", &capacity, &way, &blocksize);
            conf_set = 1;
        } else if (strcmp(argv[count], "-x") == 0)
            dump_set = 1;
        count++;
    }

    cache.n_set = (capacity / way) / blocksize;
    cache.n_block = way;
    cache.n_byte = blocksize;

    cache.s_offset = log2i(cache.n_byte);
    cache.s_index = log2i(cache.n_set);
    cache.s_tag = 32 - cache.s_offset - cache.s_index;

    cache.sets = (CACHE_SET*)malloc(sizeof(CACHE_SET) * cache.n_set);
    cache.data = (uint32_t**)malloc(sizeof(uint32_t*) * cache.n_set);
    for (i = 0; i < cache.n_set; i++) {
        cache.sets[i].blocks = (CACHE_BLOCK*)malloc(sizeof(CACHE_BLOCK) * cache.n_block);
        cache.data[i] = (uint32_t*)malloc(sizeof(uint32_t) * cache.n_block);
        for (j = 0; j < cache.n_block; j++) {
            cache.sets[i].blocks[j].valid = 0;
            cache.data[i][j] = 0;
        }
    }

    FILE *fh;
    if ((fh = fopen(argv[argc - 1], "r")) == NULL)
        exit(1);

    uint32_t seq = 0;
    char txt[20]; char addr[10]; uint32_t addrn;
    while (fgets(txt, 20, fh) != NULL) {
        if (txt[0] != 'R' && txt[0] != 'W') continue;
        
        seq++;
        for (i = 0; i < 10; i++)
            addr[i] = 0;

        for (i = 4; i < 14; i++) {
            if (txt[i] == 0) break;
            addr[i - 4] = txt[i];
        }
        addrn = clear_offset(strtol(addr, NULL, 16));

        if (txt[0] == 'R')
            cache_read(addrn, seq);
        else
            cache_write(addrn, seq);
    }

    if (conf_set)
        cdump(capacity, way, blocksize);

    sdump(total_reads, total_writes, write_backs, read_hits, write_hits, read_misses, write_misses); 
    
    if (dump_set)
        xdump(capacity / way / blocksize, way, cache.data);

    return 0;
}
