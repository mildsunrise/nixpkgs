needsLocalCflags=true

nParams=${#params[@]}
declare -i n=0
while (( "$n" < "$nParams" )); do
    p=${params[n]}
    p2=${params[n+1]:-} # handle `p` being last one
    n+=1

    case "$p" in
        -target) overridenTarget="$p2"; n+=1 ;;
        --target=*) overridenTarget="${p:9}" ;;
        *) continue;
    esac

    if [[ "$overridenTarget" != @defaultTarget@ ]]; then
        echo "Warning: supplying a non-default --target argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead." >&2

        needsLocalCflags=false
    fi
done

if $needsLocalCflags && [[ $0 != *cpp ]]; then
    extraBefore+=(-target @defaultTarget@ @machineFlags@)
fi
