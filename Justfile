# Build the current configuration, and make it the boot default
switch:
    nh os switch .

# Build the current configuration
test:
   nh os test .

# Switch to the current configuration, and show the trace
debug:
    nh os switch . -- --show-trace

# Check if the configuration works
check:
    nix flake check

# Pull from the repository remote and rebuild
sync:
    git pull
    nh os switch .

# Garbage collect the Nix store
clean:
    nh clean all
