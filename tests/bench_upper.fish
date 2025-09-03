#!/usr/bin/env fish
set -l words foo bar baz qux quux corge grault garply waldo fred plugh xyzzy thud
set -q ITER; or set ITER 1000

set -l scriptdir (status dirname)
set -l nim_str $scriptdir/../bin/str
set -l nim_strcase $scriptdir/../bin/strcase

echo "Testing Fish builtin..."
time for i in (seq $ITER)
    string upper $words >/dev/null
end

# echo "Testing Nim version..."
# time for i in (seq $ITER)
#     $nim_str upper $words >/dev/null
# end

# echo "Testing Nim version part 2..."
# time for i in (seq $ITER)
#     printf '%s\n' $words | $nim_str upper >/dev/null
# end

echo "Testing Nim version part 3..."
time for i in (seq $ITER)
    $nim_strcase upper $words >/dev/null
end

echo "Testing tr version..."
time for i in (seq $ITER)
    printf '%s\n' $words | tr [:lower:] [:upper:] >/dev/null
end

echo "Testing sed version..."
time for i in (seq $ITER)
    printf '%s\n' $words | sed y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/ >/dev/null
end

echo "Testing awk version..."
time for i in (seq $ITER)
    printf '%s\n' $words | awk '{ print toupper($0) }' >/dev/null
end

echo "Testing perl version..."
time for i in (seq $ITER)
    printf '%s\n' $words | perl -ne 'print uc($_)' >/dev/null
end

# Far too long...
# echo "Testing python version..."
# time for i in (seq $ITER)
#     printf '%s\n' $words | python3 -c 'import sys; [sys.stdout.write(l.upper()) for l in sys.stdin]' >/dev/null
# end
