#!/usr/bin/env python
import argparse

def parse_args():
    parser = argparse.ArgumentParser(
        description="A script for dynamically combining an interval list."
    )
    parser.add_argument("intervals", metavar="intervals", help="Path to an unpadded intervals file.")
    parser.add_argument("merge_count", metavar="merge_count", help="The possible number of merges to be done (num_intervals/num_gvcfs/2.5).")
    args = parser.parse_args()
    return args

def parse_interval(interval):
    colon_split = interval.split(":")
    chromosome = colon_split[0]
    dash_split = colon_split[1].split("-")
    start = int(dash_split[0])
    end = int(dash_split[1])
    return chromosome, start, end

def add_interval(lines_to_write, chr, start, end):
    lines_to_write.append(chr + ":" + str(start) + "-" + str(end))
    return chr, start, end

def main():
    inputs = parse_args()
    count = 0
    intervals = inputs.intervals
    chain_count = inputs.merge_count
    l_chr, l_start, l_end = "", 0, 0
    lines_to_write = []
    with open(intervals) as f:
        with open("out.intervals", "w") as f1:
            for line in f.readlines():
                # initialization
                if count == 0:
                    w_chr, w_start, w_end = parse_interval(line)
                    count = 1
                    continue
                # reached number to combine, so spit out and start over
                if count == chain_count:
                    l_char, l_start, l_end = add_interval(lines_to_write, w_chr, w_start, w_end)
                    w_chr, w_start, w_end = parse_interval(line)
                    count = 1
                    continue

                c_chr, c_start, c_end = parse_interval(line)
                # if adjacent keep the chain going
                if c_chr == w_chr and c_start == w_end + 1:
                    w_end = c_end
                    count += 1
                    continue
                # not adjacent, end here and start a new chain
                else:
                    l_char, l_start, l_end = add_interval(lines_to_write, w_chr, w_start, w_end)
                    w_chr, w_start, w_end = parse_interval(line)
                    count = 1
            if l_char != w_chr or l_start != w_start or l_end != w_end:
                add_interval(w_chr, w_start, w_end)
            f1.writelines("\\n".join(lines_to_write))
        
if __name__ == "__main__":
    main()