machine_hostname := shell("hostname -s")

alias s := switch
alias t := test
alias d := deploy

[private]
default:
    @just --list

todo:
    @echo TO-DOs in:
    @rg -g !{{ file_name(justfile()) }} TODO || echo "Everything's done!"


[group("local")]
up *inputs:
    nix flake update {{inputs}}

[group("local")]
switch:
    @just switch-machine

[group("local")]
test:
    @just test-machine

[group("local")]
debug:
    nh os switch . -- --show-trace

[group("local")]
check:
    nix flake check

# Garbage collect the Nix store
[group("local")]
clean:
    nh clean all


[group("deploy")]
deploy hostname mode="switch" *extra_flags:
    nh os {{mode}} -H "{{hostname}}" --target-host "root@{{hostname}}" -- {{extra_flags}}



[group("others")]
switch-machine hostname=machine_hostname:
    nh os switch . --hostname "{{hostname}}"

[group("others")]
test-machine hostname=machine_hostname:
    nh os test . --hostname "{{hostname}}"


