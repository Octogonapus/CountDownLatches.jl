using CountDownLatch
using Documenter

DocMeta.setdocmeta!(CountDownLatch, :DocTestSetup, :(using CountDownLatch); recursive=true)

makedocs(;
    modules=[CountDownLatch],
    authors="Octogonapus <firey45@gmail.com> and contributors",
    repo="https://github.com/Octogonapus/CountDownLatch.jl/blob/{commit}{path}#{line}",
    sitename="CountDownLatch.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Octogonapus.github.io/CountDownLatch.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Octogonapus/CountDownLatch.jl",
    devbranch="main",
)
