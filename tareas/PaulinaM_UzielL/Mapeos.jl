module Mapeos
using RecipesBase

export Mapeo, f

struct Mapeo
    F::Function
    x₀::Real
    n::Int
    xnn::Vector{Float64}
    x::Vector{Float64}
    y::Vector{Float64}
end

function itera_mapeo(F, x0; n_iters=100)
    xnn = Float64[x0]
    x = Float64[x0]; y = [-10000.]
    for i in 1:n_iters
        xn = xnn[end]
        Fn = F(xn)
        push!(xnn, Fn)
        push!(x, xn)
        push!(y, Fn)
        push!(x, Fn)
        push!(y, Fn)
    end
    xnn, (x, y)
end

function Mapeo(F::Function, x₀::Real, n::Int)
    xnn, x_y = itera_mapeo(F, x₀, n_iters=n)
    Mapeo(F, x₀, n, xnn, x_y...)
end

@userplot grafica_mapeo

@recipe function f(p::grafica_mapeo)
    if length(p.args) != 2 || !(typeof(p.args[1]) <: Mapeo) # Revisar esto, la primer condición no se evalúa
        error("grafica_mapeo recibe dos parámetros, el mapeo y el número de pasos.")
    end
    mapeo = p.args[1]
    n = p.args[2]
    F, x, y = mapeo.F, mapeo.x, mapeo.y
    rango_x = [minimum(x), maximum(x) + 2]
    rango_y = [minimum(y[2:end]) - 2, maximum(y) + 2]
    xx = linspace(rango_x[1], rango_x[2], 1000)
    xlims := rango_x
    ylims := rango_y
    @series begin
        seriestype := :line
        label := "F(x)"
        xx, x -> F(x)
    end
    @series begin
        seriestype := :line
        label := "y=x"
        xx, x -> x
    end
    @series begin
        seriestype := :path
        ls := :dash
        marker := (3, .5, :dot)
        label := "Trayectoria"
        x[1:n], y[1:n]
    end
end

end
