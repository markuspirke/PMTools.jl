module PMTools

import Base: minimum, maximum
import Distributions: pdf, cdf, insupport
using Distributions
import Statistics: mean, var, std, quantile
using Statistics
using Random
using ArgCheck

export ExGaussian, params, ChargeSpectrum, mean, var, std, pdf, cdf, insupport, quantile

# For the plotting extension
export chargespectrumplot, chargespectrumplot!

function chargespectrumplot end
function chargespectrumplot! end

include("charge_spectrum.jl")

end
