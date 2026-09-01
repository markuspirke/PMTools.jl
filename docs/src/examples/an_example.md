# An example

The following function determines the meaning of life.

```@example usage
using PMTools

μ, σ, c = 0.0, 1.0, 10.0

emg = PMTools.ExGaussian(μ, σ, c)

```

Examples with the same "tag" (like `usage` above) share the same Julia
process, so that everything is in the same scope. The package is therefore already
imported, so we can determine the meaning of life again `;)`

```@example usage
rand(emg)
```
