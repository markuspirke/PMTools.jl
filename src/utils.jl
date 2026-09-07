function get_test_data()
    Qs = open(joinpath(@__DIR__, "../test/testdata/signal.txt"), "r") do f
        x = [parse(Float64, l) for l in readlines(f)]
        x
    end

    Qs_noise = open(joinpath(@__DIR__, "../test/testdata/noise.txt"), "r") do f
        x = [parse(Float64, l) for l in readlines(f)]
        x
    end

    Qs, Qs_noise
end
