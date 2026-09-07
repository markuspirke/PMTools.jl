using PMTools
using NativeMinuit
using StatsBase
using Random
using Test



@testset "BLL Fit" begin
    # simulated data
    λ, q₀, σ₀, w, c₀, μ, σ, kmax = 0.8, 1.0, 0.2, 0.3, 10.0, 5.0, 2.0, 10
    cs = ChargeSpectrum(λ, q₀, σ₀, w, c₀, μ, σ, kmax)
    cs_0 = ChargeSpectrum(0.0, q₀, σ₀, w, c₀, μ, σ, kmax) # this we have in our data


    Random.seed!(123)
    Qs = rand(cs, 10_000)
    Qs_0 = rand(cs_0, 10_000)
    q₀_init, σ₀_init = mean(Qs_0), std(Qs_0)
    λ_init = 1.0
    μ_init = (mean(Qs) -  q₀_init)/λ_init
    σ_init = 0.3 * μ_init

    N_bins = 200
    bin_edges = range(extrema(Qs)..., length=N_bins+1)
    h = fit(Histogram, Qs, bin_edges)
    counts = h.weights

    bll = BinnedNLL(counts, bin_edges, cs)

    p0 = [λ_init, q₀_init, σ₀_init, w, c₀, μ_init, σ_init]

    m = Minuit(bll, p0,
            names = ["λ", "q₀", "σ₀", "w", "c₀", "μ", "σ"],
            limits = [(0.0, 10.0), (nothing, nothing), (0.0, nothing),
                        (0.0, 1.0), (0.0, nothing), (0.0, nothing),
                        (0.0, 10.0)],
            )

    migrad!(m)
    p_fit = m.values

    @test isapprox(0.799171968302097, p_fit[1], rtol=0.01)
    @test isapprox(0.9281309744858782, p_fit[2], rtol=0.1)
    @test 7 == n_free(m.params)

    @test isapprox(0.9702282241081267, goodness_of_fit(bll, m), rtol=0.1)

    # # real data
    # using HDF5
    # using Unitful
    # f = h5open("/Users/markuspirke/Nextcloud/PMT-Measurements/ST5211/ST5211_20260805.h5")

    # hv = 1400
    # waveforms = read(f["all/$(hv)/waveforms"])
    # Δt = read(f["all/$(hv)/waveform_info/h_int"])
    # T = read(f["all/$(hv)/waveform_info/measurement_time"])
    # a = read(f["all/$(hv)/waveform_info/v_gain"])[1]
    # b = read(f["all/$(hv)/waveform_info/y_off"])[1]
    # R = 50.0

    # wfs, wf_params = PMTools.read_waveforms(f, "all/$(hv)/waveforms"), PMTools.WaveformParameters(R, T, Δt, a, b)
    # Qs = [PMTools.integrate(wf, wf_params, 30u"ns", 120u"ns") for wf in wfs]
    # Qs = ustrip.(-1 .* Qs) * 1e12
    # Qs_0 = [PMTools.integrate(wf, wf_params, 120u"ns", 200u"ns") for wf in wfs]
    # Qs_0 = ustrip.(-1 .* Qs_0) * 1e12

    # q₀_init, σ₀_init = mean(Qs_0), std(Qs_0)
    # λ_init = 1.0
    # μ_init = (mean(Qs) -  q₀_init)/λ_init
    # σ_init = 0.3 * μ_init

    # p0 = [λ_init, q₀_init, σ₀_init, w, c₀, μ_init, σ_init]
    # cs = ChargeSpectrum(p0..., 20)


    # N_bins = 200
    # bin_edges = range(extrema(Qs)..., length=N_bins+1)
    # h = fit(Histogram, Qs, bin_edges)
    # counts = h.weights

    # bll = BinnedNLL(counts, bin_edges, cs)

    # m = Minuit(bll, p0,
    #         names = ["λ", "q₀", "σ₀", "w", "c₀", "μ", "σ"],
    #         limits = [(0.0, 10.0), (nothing, nothing), (0.0, nothing),
    #                     (0.0, 1.0), (0.0, nothing), (0.0, nothing),
    #                     (0.0, nothing)],
    #         )

    # migrad!(m)

    # gof = m.fval * 2
    # ndf = N_bins - n_free(m.params) - 1

    # @show gof/ndf

    # p_fit = collect(m.values)
    # cs_fit = ChargeSpectrum(p_fit..., kmax)

    # fig= Figure();
    # ax = Axis(fig[1, 1], yscale=log10)
    # hist!(ax, Qs, bins=N_bins, normalization=:pdf, color=:black)
    # lines!(ax, cs_fit, color=:red)
    # current_figure()

    # gain = cs_fit.μ * 1e-12 * 6.241e18
end
