function anima_trayectoria(iters_x::Vector, iters_y::Vector;
    xlims=(0, 1), ylims=(0, 1), kwargs...)
    anim = @animate for i in 1:length(iters_x)
        scatter([iters_x[i]], [iters_y[i]], label=""; kwargs...)
        if i != 1
            plot!([iters_x[1:i]], [iters_y[1:i]], label="Trayectoria")
        end
        xlims!(xlims); ylims!(ylims)
    end
    return anim
end

function genera_diagrama(F::Function, rango_c::Vector, n::Int)

end
