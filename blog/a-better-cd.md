% ABCD -- a better cd
% Brihat
% December 1, 2013

ABCD -- a better cd
===================

Unix's builtin `cd` command has a very nice feature, "cd minus":

```
cd -
   Go back to the direcotry previous to the current one.
   Same as: cd "$OLDPWD"
```

Let's make `cd` better. Let's extend this functionality, such that:

-------   -------------------------------------------------------
`cd --`   Go back two directories previous to the current one.
`cd ---`  Go back three directories previous to the current one.
-------   -------------------------------------------------------

Why stop there? How about `cd -4`, `cd -5` and so on?
In the process, of course we want to be backwards-compatible with
the fundamental properties of `cd`:

-------   ---------------------------------
`cd DIR`  Change to directory DIR
`cd`      Change to $HOME. Same as `cd ~`
-------   ---------------------------------

To implement this, let's make use of bash's building blocks:
`pushd` and `popd`. Here it is how to do it:

```shell
function cd()  {
    local dir="$1";  local old=()
    [[ -z "$dir" ]] && dir="$HOME"
    [[ "$dir" == "-" ]] && dir=-1
    [[ "$dir" == "--" ]] && dir=-2
    [[ "$dir" == "---" ]] && dir=-3
    local head="${dir:0:1}"   # first char of $dir
    if [[ "$head" == "-" ]]; then
        while [[ "$dir" -lt 0 ]]; do
            old+=(`pwd`)
            popd > /dev/null
            let dir=dir+1
        done
        for (( idx="${#old[@]}"-1 ; idx>=0 ; idx-- )); do
            pushd -n "${old[idx]}" > /dev/null
        done
    elif [[ "$head" == "+" ]]; then
        popd "$dir" > /dev/null
    else
        pushd "$dir" > /dev/null
    fi
}

```

You can simply copy-paste the above in your `~/.bashrc` for example.

Examples
---------

Also mention dirs -v and dirs -c


How does the code work
----------------------

Caveats
-------

1. `cd` takes two options,  `-L` and `-P`, related to symlink-following (or not).
   The above code does not consider that. It always follows symlinks, just like the
   default behavior of `cd`.
2. If you have turned on `autocd` option of Bash v4 (and later), the our own `cd`
   is not triggered. It uses the builtin `cd` always.


