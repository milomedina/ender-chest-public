/*
 * Sungwon Cho (known as Sam Jo)
 * Time: 2015-11-02T13:01+09:00
 */

#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "cachelab.h"

// denote one cache block
typedef struct {
    int valid;      // valid tag
    long tag;       // the tag
    int access_seq; // last access seq
} CACHE_BLOCK;

// denote one cache line
typedef struct {   
    CACHE_BLOCK *blocks;
} CACHE_LINE;

// denote the cache
typedef struct {
    int n_line;     // number of lines
    int n_block;    // number of blocks
    int n_byte;     // number of bytes

    int tag_size;   // tag size
    int index_size; // index size
    int block_size; // block size
    
    CACHE_LINE *lines;
} CACHE;

// the cache
CACHE cache;

// hit, miss, eviction count
int hit_count = 0;
int miss_count = 0;
int eviction_count = 0;


// return b^e
int powi(int b, int e) {
    int r = 1;
    for (int i = 0; i < e; i++)
        r *= b;
    return r;
}

// return index for given address
int get_row(long addr) {
    return (unsigned)addr << cache.tag_size >> cache.tag_size >> cache.block_size; 
}

// return tag for given address
long get_tag(long addr) {
    return (unsigned)addr >> cache.block_size >> cache.index_size;
}


// simulate cache access for given address and sequence
void access_cache(long addr, int seq) {
    // get row index and tag for given address
    int row = get_row(addr);
    long tag = get_tag(addr);

    // get cache line
    CACHE_LINE *line = &cache.lines[row];

    // search block by block in the line
    for (int i = 0; i < cache.n_block; i++) {
        CACHE_BLOCK *block = &line->blocks[i];

        // if the block is valid and tag matches
        if (block->valid && block->tag == tag) {
            // hit. increase hit count and update access sequence
            hit_count++;
            block->access_seq = seq;
            return;
        }
    }

    // otherwise, miss. increase miss count
    miss_count++;

    // search block by block for empty block
    for (int i = 0; i < cache.n_block; i++) {
        CACHE_BLOCK *block = &line->blocks[i];

        // if the block is empty, i.e not valid
        if (!block->valid) {
            // store tag and access sequence to the block
            block->valid = 1;
            block->tag = tag;
            block->access_seq = seq;
            return;
        }
    }

    // otherwise, need eviction. increase eviction count
    eviction_count++;

    // store eviction block index, and smallest access sequence
    int block_index, access_seq_sm = 1 << 30;
    for (int i = 0; i < cache.n_block; i++) {
        CACHE_BLOCK *block = &line->blocks[i];
        if (block->access_seq < access_seq_sm) {
            access_seq_sm = block->access_seq;
            block_index = i;
        }
    }

    // store tag in the eviction block, and update access sequence
    (line->blocks[block_index]).tag = tag;
    (line->blocks[block_index]).access_seq = seq;
}

int main(int argc, char **argv)
{
    int ns = 0, ne = 0, nb = 0;
    char *file_name = NULL;
    
    // parse arguments
    int opt = 0;
    while ((opt = getopt(argc, argv, "s:E:b:t:")) != -1) {
        switch (opt) {
            case 's':
                ns = atoi(optarg);
                break;
            case 'E':
                ne = atoi(optarg);
                break;
            case 'b':
                nb = atoi(optarg);
                break;
            case 't':
                file_name = optarg;
                break;
            default:
                fprintf(stderr, "usages: ./csim -s <s> -E <E> -b <b> -t <tracefile>\n");
                return 1;
        }
    }
    
    // store number of lines, blocks, bytes
    cache.n_line = powi(2, ns);
    cache.n_block = ne;
    cache.n_byte = powi(2, nb);

    // store tag, index, block size
    cache.tag_size = 64 - ns - nb;
    cache.index_size = ns;
    cache.block_size = nb;

    // allocate cache lines
    cache.lines = (CACHE_LINE*)malloc(sizeof(CACHE_LINE) * cache.n_line);
    for (int i = 0; i < cache.n_line; i++) {
        // allocate cache blocks
        cache.lines[i].blocks = (CACHE_BLOCK*)malloc(sizeof(CACHE_BLOCK) * cache.n_block);
        for (int j = 0; j < cache.n_block; j++)
            cache.lines[i].blocks[j].valid = 0; // init valid bit to 0
    }
    
    FILE *fh;
    if ((fh = fopen(file_name, "r")) == NULL)
        return 1;

    int seq = 0;
    char txt[30]; char addr[9]; long addrl; 
    // read file oneline by oneline
    while (fgets(txt, 30, fh) != NULL) {
        if (txt[0] != ' ') continue;

        // add sequence number
        seq++;

        // init address variable
        for (int i = 0; i < 9; i++)
            addr[i] = 0;

        // copy to address variable
        for (int i = 3; i < 30; i++) {
            if (txt[i] == ',') break;
            addr[i - 3] = txt[i];
        }

        // get address of long type
        addrl = strtol(addr, NULL, 16);

        // if load or store, access cache once, if modify, access cache twice
        if (txt[1] == 'L' || txt[1] == 'S')
            access_cache(addrl, seq);
        else if (txt[1] == 'M') {
            access_cache(addrl, seq);
            access_cache(addrl, seq);
        }
    }

    fclose(fh);
    
    // print the result
    printSummary(hit_count, miss_count, eviction_count);
    return 0;
}
