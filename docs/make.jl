using CountDownLatches
using Documenter

DocMeta.setdocmeta!(
    CountDownLatches,
    :DocTestSetup,
    :(using CountDownLatches);
    recursive = true,
)

makedocs(;
    modules = [CountDownLatches],
    authors = "Octogonapus <firey45@gmail.com> and contributors",
    repo = "https://github.com/Octogonapus/CountDownLatches.jl/blob/{commit}{path}#{line}",
    sitename = "CountDownLatches.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://Octogonapus.github.io/CountDownLatches.jl",
        assets = String[],
    ),
    pages = ["Home" => "index.md"],
)

deploydocs(; repo = "github.com/Octogonapus/CountDownLatches.jl", devbranch = "main")
