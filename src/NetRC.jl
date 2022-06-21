module NetRC

## Modules Used
using Dates
using DelimitedFiles
using Logging
using Printf

## Exporting the following functions:
export
        netrc_file, netrc_check, netrc_read, netrc_write,
        netrc_add!, netrc_modify!, netrc_rm!,
        netrc_checkmachine

## Functions

modulelog() = "$(now()) - NetRC.jl"

netrc_file()  = joinpath(homedir(),".netrc")
netrc_check() = isfile(netrc_file())

function netrc_read()

    netrc = Dict{String,Vector{String}}()

    if netrc_check()

        data = readdlm(netrc_file(),' ')

        netrc["machine"]  = data[:,2]
        netrc["login"]    = data[:,4]
        netrc["password"] = data[:,6]

    else

        @warn "$(modulelog()) - .netrc file at $(netrc_file()) does not exist, creating ..."

        netrc["machine"]  = Vector{String}(undef)
        netrc["login"]    = Vector{String}(undef)
        netrc["password"] = Vector{String}(undef)

    end

    return netrc

end

function netrc_write(
    netrc :: Dict
)

    nserver = length(netrc["machine"])
    open(netrc_file(),"w") do f
        
        for ii = 1 : nserver

            write(f,"machine $(netrc["machine"][ii]) login $(netrc["login"][ii]) password $(netrc["password"][ii])\n")

        end

    end

end

function netrc_add!(
    netrc :: Dict;
    machine  :: AbstractString,
    login    :: AbstractString,
    password :: AbstractString,
)

    imach = netrc["machine"] .== machine
    if iszero(sum(imach))
        netrc["machine"]  = vcat(netrc["machine"], machine)
        netrc["login"]    = vcat(netrc["login"],   login)
        netrc["password"] = vcat(netrc["password"],password)
    else
        error("$(modulelog()) - A prexisting machine $machine exists, and additional login and password information cannot be added, use the function netrc_modify! to modify login and password information")
    end

    return

end

function netrc_modify!(
    netrc :: Dict;
    machine  :: AbstractString,
    login    :: AbstractString = "",
    password :: AbstractString = "",
)

    imach = findfirst(netrc["machine"] .== machine)
    if login != "";    netrc["login"][imach]    = login    end
    if password != ""; netrc["password"][imach] = password end

    return

end

function netrc_rm!(
    netrc :: Dict;
    machine  :: AbstractString,
)

    imach = netrc["machine"] .!= machine
    if sum(imach) < length(netrc["machine"])
        netrc["machine"]  = netrc["machine"][imach]
        netrc["login"]    = netrc["login"][imach]
        netrc["password"] = netrc["password"][imach]
    end

    return

end

function netrc_checkmachine(
    netrc :: Dict;
    machine :: AbstractString,
)

    imach = netrc["machine"] .== machine
    if iszero(sum(imach))
        return false
    else
        return true
    end

end

end
