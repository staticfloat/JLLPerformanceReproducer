# Run this once to precompile, then run again to get acutal timings
push!(LOAD_PATH, pwd())

foo_time = @elapsed using Foo
@info("Foo load time: $(foo_time)")

bar_time = @elapsed using Bar
@info("Bar load time: $(bar_time)")
