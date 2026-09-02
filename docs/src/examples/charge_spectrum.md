# PMT Charge Spectrum

The following show how we can initialize a PMT charge spectrum for some given parameters
```@example usage
using PMTools

λ, q₀, σ₀, w, c₀, μ, σ, kmax = 3.0, 1.0, 0.2, 0.3, 10.0, 5.0, 2.0, 10
cs = ChargeSpectrum(λ, q₀, σ₀, w, c₀, μ, σ, kmax)
```

`ChargeSpectrum` is extending the `Distributions.jl` ecosystem and has full functionality that is expected from a distribution.
```@example usage
rand(cs)
```
By loading one of the Makie plotting backend we can also easily visualize the spectrum out of the box.
```@example usage
using CairoMakie
lines(cs)
```
