module Newton
"""
    newton(f, fprime, x0, número_iteraciones)

`newton` es una implementación unidimensional compleja del método de Newton para encontrar raíces de la función `f`.

# Argumentos

Para poder utilizar la función se requieren los siguientes argumentos:

* `f`, la función compleja (real) de variable compleja (real) de la que se quiere buscar una raíz (un punto \$ a \$ tales que \$ f(a) = 0 \$),
* `f_prime`, la función derivada de `f`, y,
* `x0`, una adivinanza inicial sobre la posición de la raíz.

Opcionalmente, se puede especificar lo siguiente:

* `número_iteraciones`, el número de iteraciones a realizar. (Por defecto está configurado en 1000 iteraciones.)

`newton` requiere que tanto `f` como `fprime` sean funciones, que `x0` sea un número y que `número_iteraciones` sea un número entero. `x0`, en particular, siempre es convertida a un número flotante para mejorar la estabilidad de tipo.

# Ejemplos
```julia-repl
    julia> newton(x -> x^2 - 2, x -> 2*x, 2, 5)
    1.4142135623730951

    julia> newton(x -> x^2 - 2, x -> 2*x, 1.4, 100)
    1.414213562373095

    julia> newton(x -> x^2 - 2, x -> 2*x, φ, 1)
    1.4270509831248424

    julia> newton(x -> x^2 - 2, x -> 2*x, φ, 10)
    1.414213562373095

    julia> newton(z -> z^2 + 1, z -> 2*z, -0.1*im, 5)
    0.0 - 1.0032578510960606im

    julia> newton(z -> z^2 + 1, z -> 2*z, -0.1*im, 10)
    0.0 - 1.0im
```
"""
function newton(f::Function, fprime::Function, x0::Number, número_iteraciones::Int = 1000)
    
    punto_actual = float(x0)
    
    for i in 1:número_iteraciones
        punto_actual -= f(punto_actual)/fprime(punto_actual)
    end
    
    return(punto_actual)
end

#Exporta la función:

export newton

end