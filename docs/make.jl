using NetRC
using Documenter

DocMeta.setdocmeta!(NetRC, :DocTestSetup, :(using NetRC); recursive=true)

makedocs(;
    modules=[NetRC],
    authors="Nathanael Wong <natgeo.wong@outlook.com>",
    repo="https://github.com/natgeo-wong/NetRC.jl/blob/{commit}{path}#{line}",
    sitename="NetRC.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://natgeo-wong.github.io/NetRC.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/natgeo-wong/NetRC.jl",
    devbranch="main",
)
