using Documenter, PMTools

makedocs(;
    modules = [PMTools],
    sitename = "PMTools.jl",
    authors = "Markus Pirke",
    format = Documenter.HTML(;
        assets = ["assets/custom.css"],
        sidebar_sitename = true,
        collapselevel = 2,
        warn_outdated = true,
    ),
    warnonly = [:missing_docs],
    pages = [
        "Home" => "index.md",
        "Examples" => Any[
            "examples/charge_spectrum.md",
        ],
        "API" => "api.md"
    ],
    repo = Documenter.Remotes.URL(
        "https://git.ecap.work/xe91xote/PMTools.jl/blob/{commit}{path}#L{line}",
        "https://git.ecap.work/xe91xote/PMTools.jl"
    ),
)

deploydocs(;
  repo = "git.ecap.work/xe91xote/PMTools.jl",
  devbranch = "main",
  push_preview=true
)
