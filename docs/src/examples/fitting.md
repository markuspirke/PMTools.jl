# Fitting

The following shows how we can estimate parameters of the charge spectrum, by fitting the spectrum to a histogram.
Here we use the standard tool of high energy physicists when performing fits: Minuit (`NativeMinuit.jl`).

## Sampling data
First we need to loading packages and define a charge spectrum where we sample our data from.

```@example usage
using PMTools, NativeMinuit, StatsBase

λ, q₀, σ₀, w, c₀, μ, σ, kmax = 0.8, 1.0, 0.2, 0.3, 10.0, 6.0, 2.0, 10
cs = ChargeSpectrum(λ, q₀, σ₀, w, c₀, μ, σ, kmax)
```

Now we sample from this distribution
```@example usage
Qs = rand(cs, 10_000)
```

In an experiment we usually can infer the average noise and standard deviation from regions in the time series where not pulse was present. We simulate this by sampling from a charge spectrum with $\lambda$ set to 0.0.
```@example usage
cs = ChargeSpectrum(0.0, q₀, σ₀, w, c₀, μ, σ, kmax)
Qs_noise = rand(cs, 10_000)
```
The sample mean and standard deviation can directly be used as starting parameters. Based on these and a on a rough guess on the average number of photoelectrons we can also set the starting parameter of the gain.
```@example usage
q₀_init, σ₀_init = mean(Qs_noise), std(Qs_noise)
λ_init = 1.0
μ_init = (mean(Qs) -  q₀_init)/λ_init
σ_init = 0.3 * μ_init

p0 = [λ_init, q₀_init, σ₀_init, 0.5, μ_init, μ_init, σ_init]
```

## Binning and likelihood definition
Now we need to bin our data and construct the likelihood function.
```@example usage
N_bins = 200
bin_edges = range(extrema(Qs)..., length=N_bins+1)
h = fit(Histogram, Qs, bin_edges)
counts = h.weights

bll = BinnedNLL(counts, bin_edges, cs)
```

## Minuit fit
What follows is standard `NativeMinuit.jl` code
```@example usage
m = Minuit(bll, p0,
        names = ["λ", "q₀", "σ₀", "w", "c₀", "μ", "σ"],
        limits = [(0.0, 10.0), (nothing, nothing), (0.0, nothing),
                    (0.0, 1.0), (0.0, nothing), (0.0, nothing),
                    (0.0, 10.0)],
        )

migrad!(m)
```

## Visualization
We can visualize the data and the fit.
```@example usage
using CairoMakie
fig = Figure()
ax = Axis(fig[1,1], xlabel="Charge / arb")
stephist!(ax, Qs, bins=N_bins, color=:black, normalization=:pdf)
p_fit = m.values
lines!(ax, ChargeSpectrum(p_fit..., kmax), color=:red)
fig
```
