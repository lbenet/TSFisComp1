doc"""
    newton(f, f', x0, n_iter)
Devuelve las raíces de la función `f`.

"""
function newton(f, fprime, x0; n_iter::Int64=1000)
    
    x_nn = x_n = x0
    for i in 1:n_iter
        x_nn = x_n - (f(x_n) / fprime(x_n))
        x_n = x_nn
    end
    return float(x_nn)
end
