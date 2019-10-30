module Foo
using Pkg, Pkg.Artifacts, Libdl

function __init__()
    init_time = @elapsed begin
        expat_dir = artifact"Expat"
        global libexpat = dlopen(joinpath(expat_dir, "lib", "libexpat"))
    end
    @info("Foo __init__() self-time: $(init_time)")
end

if ccall(:jl_generating_output, Cint, ()) == 1
    precompile(Tuple{typeof(__init__)})
end

end
