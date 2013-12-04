% ABCD -- a better cd
% Brihat
% December 1, 2013

ABCD -- a better cd
===================

Unix's builtin `cd` command has a very nice feature:

```
cd -
   Go back to the direcotry previous to the current one.
   Same as: cd "$OLDPWD"
```

I wanted to extend this functionality, such that:


```
cd --
   Go back two directories previous to the current one.

cd ---
   Go back three directories previous to the current one.
```

Why stop there? How about `cd -4`, `cd -5` and so on?
To implement this, let's make use of bash's building blocks:
`pushd` and `popd`.

Here it is how to do it:

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


