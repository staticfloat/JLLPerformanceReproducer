# Run this once to precompile, then run again to get acutal timings
push!(LOAD_PATH, pwd())

@info("Foo load time:")
@time using Foo

@info("Bar load time:")
@time using Bar
