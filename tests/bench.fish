#!/usr/bin/env fish
set -q ITER; or set ITER 1000
set -l words foo bar baz qux quux corge grault garply waldo fred plugh xyzzy thud

set -l scriptdir (status dirname)
set -l nim_str $scriptdir/../bin/str
set -l nim_str_fast $scriptdir/../bin/str-fast

# DRY benchmark loop
function bench_loop
    set label $argv[1]
    set exe $argv[2]
    set sub $argv[3]
    set args $argv[4..-1]
    echo "Testing $label $sub (ITER=$ITER)..."
    time for i in (seq $ITER)
        $exe $sub $args >/dev/null
    end
end

# Subcommands to test
set -l subs upper lower length

# Precompute blue separator line
set -l _sep_line (string repeat -n 56 =)

# Fish builtin (string)
for s in $subs
    bench_loop "Fish builtin string" string $s $words
    bench_loop "Nim str" $nim_str $s $words
    # bench_loop "Nim str fast" $nim_str_fast $s $words

    echo (set_color blue)$_sep_line(set_color normal)
end

echo "Set ITER to adjust iterations: ITER=300 fish tests/bench.fish"
