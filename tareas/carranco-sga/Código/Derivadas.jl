module Derivadas

"""
    derivada_derecha(f, x0, h)

`derivada_derecha` es una función que calcula la derivada numérica derecha de la función dada en el punto suministrado con el tamaño de paso definido.

# Definición

La derivada numérica derecha de `f` en el punto `x0` con tamaño de paso `h` está dada por: 

\$ f'_+ (x_0; h) = \frac{f(x_0 + h) - f(x_0)}{h}. \$

# Argumentos

Para poder utilizar la función se requieren los siguientes argumentos:

* `f`, la función (compleja) de variable (compleja) de la que se quiere calcular la derivada,
* `x0`, el punto en el que se desea calcular la derivada, y,
* `h`, el tamaño de paso usado para aproximar la derivada exacta.

`derivada_derecha` requiere que `f` sea una función, y que `x0` y `h` sean números. En particular, para mejorar la estabilidad de tipo, `x0` y `h` son convertidos a números flotantes de 64 bits.

# Ejemplos:
```julia-repl
    julia> derivada_derecha(x -> x, 1, 0.01)
    1.0000000000000009

    julia> derivada_derecha(x -> x^2, 1, 0.01)
    2.0100000000000007

    julia> derivada_derecha(x -> sin(x), 0, 0.001)
    0.9999998333333416

    julia> derivada_derecha(x -> exp(x), 0, 0.001)
    1.0005001667083846
```
"""
function derivada_derecha(f::Function, x0::Number, h::Number)
    
    x0 = float(x0)
    h = float(h)
    
    derivada = (f(x0 + h) - f(x0))/h
    
    return(derivada)
end

#Extensión para usar la derivada con la función `newton` de `Newton.jl`.
derivada_derecha(h) = (f, x0) ->  derivada_derecha(f, x0, h)

"""
    derivada_simétrica(f, x0, h)

`derivada_simétrica` es una función que calcula la derivada numérica simétrica de la función dada en el punto suministrado con el tamaño de paso definido.

# Definición

La derivada numérica simétrica de `f` en el punto `x0` con tamaño de paso `h` está dada por: 

\$ f'_{sym} (x_0; h) = \frac{f(x_0 + h) - f(x_0 - h)}{2h}. \$

# Argumentos

Para poder utilizar la función se requieren los siguientes argumentos:

* `f`, la función (compleja) de variable (compleja) de la que se quiere calcular la derivada,
* `x0`, el punto en el que se desea calcular la derivada, y,
* `h`, el tamaño de paso usado para aproximar la derivada exacta.

`derivada_simétrica` requiere que `f` sea una función, y que `x0` y `h` sean números. En particular, para mejorar la estabilidad de tipo, `x0` y `h` son convertidos a números flotantes de 64 bits.

# Ejemplos:
```julia-repl
    julia> derivada_simétrica(x -> x, 1, 0.01)
    1.0000000000000009

    julia> derivada_simétrica(x -> x^2, 1, 0.01)
    2.0000000000000018

    julia> derivada_simétrica(x -> sin(x), 0, 0.001)
    0.9999998333333416

    julia> derivada_simétrica(x -> exp(x), 0, 0.001)
    1.0000001666666813
```
"""
function derivada_simétrica(f::Function, x0::Number, h::Number)
    
    x0 = float(x0)
    h = float(h)
    
    derivada = (f(x0 + h) - f(x0 - h))/(2*h)
    
    return(derivada)
end

#Extensión para usar la derivada con la función `newton` de `Newton.jl`.
derivada_simétrica(h) = (f, x0) ->  derivada_simétrica(f, x0, h)

"""
    derivada_compleja(f, x0, h)

`derivada_compleja` es una función que calcula la derivada numérica compleja de la función dada en el punto suministrado con el tamaño de paso definido.

# Definición

La derivada numérica compleja de `f` en el punto `x0` con tamaño de paso `h` está dada por: 

\$ f'_{cmplx} (x_0; h) = \\Im \\left( \\frac{f(x_0 + ih)}{h} \\right). \$

# Argumentos

Para poder utilizar la función se requieren los siguientes argumentos:

* `f`, la función (real) de variable (real) de la que se quiere calcular la derivada,
* `x0`, el punto en el que se desea calcular la derivada, y,
* `h`, el tamaño de paso usado para aproximar la derivada exacta.

`derivada_compleja` requiere que `f` sea una función, y que `x0` y `h` sean números. En particular, para mejorar la estabilidad de tipo, `x0` y `h` son convertidos a números flotantes de 64 bits.

# Ejemplos:
```julia-repl
    julia> derivada_compleja(x -> x, 1, 0.01)
    1.0

    julia> derivada_compleja(x -> x^2, 1, 0.01)
    2.0

    julia> derivada_compleja(x -> sin(x), 0, 0.001)
    1.0000001666666751

    julia> derivada_compleja(x -> exp(x), 0, 0.001)
    0.9999998333333416
```

# Notas:

*Nota*: Por la definición de la derivada numérica compleja, esta sólo funciona para funciones reales que puedan ser extendidas al plano complejo con una función analítica en una vecindad del punto de interés. Esta función no aproxima adecuadamente la derivada de una función compleja.
"""
function derivada_compleja(f::Function, x0::Number, h::Number)

    x0 = float(x0)
    h = float(h)
    
    derivada = f(x0 + h*im)/ h
    
    return(derivada.im)
end

#Extensión para usar la derivada con la función `newton` de `Newton.jl`.
derivada_compleja(h) = (f, x0) ->  derivada_compleja(f, x0, h)

#Exporta las funciones al entorno global:

export derivada_derecha
export derivada_simétrica
export derivada_compleja

end