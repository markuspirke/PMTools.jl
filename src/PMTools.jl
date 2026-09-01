module PMTools

import Distributions: pdf, cdf
using Distributions
import Statistics: mean
using Statistics
using Random
using ArgCheck

export ExGaussian, params, ChargeSpectrum, mean, var, std, pdf, cdf

include("charge_spectrum.jl")

end
