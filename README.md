# JLL package slowdown reproducer

JLL packages seem strangely slow to load.  This repo contains two modules that both use a macro in `Pkg.Artifacts` to open a TOML file, parse it, install an artifact if it doesn't already exist, and return the path to it.  We're most interested in the fast path, e.g. the artifact already exists and we should go from zero to dlopen'ed very quickly.  We load two modules so that we can eliminate issues with pieces of `Pkg.Artifacts` itself not being loaded properly, the need to load global TOML files once, etc...  We instrument the modules to both time how long running their contents takes, as well as from the outside to see what the total `using` time is:

```
# Ignore first run because that precompiles the modules themselves
$ julia-release-1.3 --color=yes timing_test.jl >/dev/null
$ julia-release-1.3 --color=yes timing_test.jl 
[ Info: Foo __init__() self-time: 1.090927152
[ Info: Foo load time: 1.348660712
[ Info: Bar __init__() self-time: 0.001344999
[ Info: Bar load time: 0.133114606
```

This shows that inference, or `.ji` file loading, or something along those lines is costing us ~100x what actually running the `__init__` function should, despite the fact that we have explicitly asked for `__init__()` to be precompiled.

As an interesting aside, the `Foo.ji` file that is generated from the `Foo.jl` file here is 270KB large.
