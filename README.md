# JLL package slowdown reproducer

JLL packages seem strangely slow to load.  Using Julia 1.3-rc4, we see:

```
# Run once to precompile
$ julia-release-1.3 timing_test.jl >/dev/null
$ julia-release-1.3 timing_test.jl
[ Info: Foo load time:
  1.203080 seconds (4.10 M allocations: 207.608 MiB, 2.10% gc time)
[ Info: Bar load time:
  0.128752 seconds (130.15 k allocations: 7.637 MiB)
```

A fair chunk of the initial `Foo` load time is constant start-up costs, (loading TOML files, precompiling Pkg.Artifacts functions, etc...) but much of the time seems to come from outside of the `__init__()` function.  Indeed, instrumenting the `__init__()` function by wrapping it in a giant `@time` block gives the following timings:

```
$ julia-release-1.3 timing_test.jl 
[ Info: Foo load time:
  1.043252 seconds (3.97 M allocations: 198.970 MiB, 2.47% gc time)
  1.198487 seconds (4.11 M allocations: 208.005 MiB, 2.15% gc time)
[ Info: Bar load time:
  0.001274 seconds (2.15 k allocations: 141.266 KiB)
  0.139161 seconds (128.99 k allocations: 7.585 MiB)
```

This shows that inference, or `.ji` file loading, or something along those lines is costing us 100x what actually running the `__init__` function should, despite the fact that we have explicitly asked for `__init__()` to be precompiled.

As an interesting aside, the `Foo.ji` file that is generated from the `Foo.jl` file here is 270KB large.
