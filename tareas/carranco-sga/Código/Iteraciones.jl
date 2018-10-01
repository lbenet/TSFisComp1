module Iteraciones

"""
    iteraciones(f::Function, número_iteraciones::Int, x0)

Genera un array unidimensional de tamaño `1 + número_iteraciones` que en la entrada ``i + 1`` tiene al elemento proveniente de iterar `x0` ``ì`` veces con la función `f`. En el caso de ```i = 1``, el valor en el array es igual a la condición inicial usada.

# Argumentos

Requiere:

+ `f`, una función,
+ `número_iteraciones`, un entero que dicta el número de iteraciones a realizar, y,
+ `x0`, el punto inicial.

En particular, la condición inicial suministrada `x0` es convertida a su respectivo flotante antes de calcular los iterados; esto para facilitar el uso de arrays: es necesario que la función que se itera admita valores flotantes o estructuras con valores flotantes.

# Ejemplo
```julia-repl

julia> iteraciones(x->x^2, 5, 2)
6-element Array{Int64,1}:
          2
          4
         16
        256
      65536
 4294967296

julia> v = x -> [x[1] - x[2], x[1]*x[2]]; iteraciones(v, 2, [1, 3])
3-element Array{Array{Float64,1},1}:
 [1.0, 3.0]  
 [-2.0, 3.0] 
 [-5.0, -6.0]
```
"""
function iteraciones(f::Function, número_iteraciones::Int, x0)
    
    valor = float.(x0)
    
    iterados = [valor]
    
    for i in 1:número_iteraciones
        
        valor = f(valor)
        push!(iterados, valor)
    end
    
    return(iterados)
end

"""
    iterar(f::Function, número_iteraciones::Int, x0)

Devuelve el resultado de iterar `número_iteraciones` veces la función `f` con condición inicial `x0`.

# Argumentos

Requiere:

+ `f`, una función,
+ `número_iteraciones`, un entero que dicta el número de iteraciones a realizar, y,
+ `x0`, el punto inicial.

En particular, la condición inicial suministrada `x0` es convertida a su respectivo flotante antes de calcular los iterados; esto para facilitar el uso de arrays: es necesario que la función que se itera admita valores flotantes o estructuras con valores flotantes.

# Ejemplo
```julia-repl

julia> iterar(x->x^2, 5, 2)
4294967296

julia> v = x -> [x[1] - x[2], x[1]*x[2]]; iterar(v, 2, [1, 3])
2-element Array{Float64,1}:
 -5.0
 -6.0
```
"""
function iterar(f::Function, número_iteraciones::Int, x0)
    
    iterados = iteraciones(f, número_iteraciones, x0)
    valor = last(iterados)
    
    return(valor)
end

"""
    análisis_gráfico(f::Function, número_iteraciones::Int, x0::Array{N, 1}, a::Real, b::Real, paso::Real, c::Real, d::Real; title::String = "", ylabel::String = "\$f(x)\$", colores::Array) where N <: Real

Genera un análisis gráfico de los iterados de la función `f` por el `número_iteraciones` dado con condiciones iniciales iguales a las entradas del vector `x0`. La ventana de graficación usada está dada por `` [a, b]\\times[c, d] ``. Para graficar la función, se usan puntos de muestreo separados por `paso` en el intervalo `` [a,b] ``. El título y el título del eje para los iterados se pueden cambiar usando los mismos argumentos que en `Plots.jl`. Los colores de las líneas para los iterados se deben suministrar como un array de colores al keyword argument `colores`.

# Argumentos

Requiere:

+ `f`, una función,
+ `número_iteraciones`, un entero que dicta el número de iteraciones a realizar,
+ `x0`, el array de puntos iniciales usado,
+ `a`, `b`, `c` y `d`, los parámetros usados para establecer la ventana de visualización, y,
+ `colores`, el array de colores para las líneas de los iterados.

En particular, las condiciones iniciales suministradas (las componentes de `x0`) son convertidas a sus respectivos flotantes antes de calcular los iterados; esto para facilitar el uso de arrays: es necesario que la función que se itera admita valores flotantes o estructuras con valores flotantes.

Opcionalmente se pueden especificar:

+ `title`, el título de la gráfica mediante un string, y,
+ `ylabel`, el título del eje y mediante un string.

En particular, `title` y `ylabel` son interpretados como strings con ecuaciones escritas en  `` \\LaTeX `` mediante el comando `LaTeXString`. Esto quiere decir que el texto no es interpretado dentro del entorno matemático de  `` \\LaTeX `` sin incluirlo entre pares de  `` \\ \$ `` (signos de dinero escapados).

# Ejemplo

Para visualizar los primeros cinco iterados de la función `` x \\mapsto \\sqrt{x} `` en la ventana `` [0, 1] \\times [0,1] `` con la función graficada con una resolución de paso igual a 0.01 con condición inicial 0.5 se puede usar el comando:
```julia-repl

julia> análisis_gráfico(x->sqrt(x), 5, [0.5], 0, 1, 0.01, 0, 1, colores = [:green])
```

Para hacer lo mismo, pero cambiando el título a "Ejemplo", el título del eje y a "Eje y" y agregando los iterados correspondientes a la condición inicial igual a 0.7 en color rojo se puede usar:
```julia-repl

julia> análisis_gráfico(x->sqrt(x), 5, [0.5, 0.7], 0, 1, 0.01, 0, 1, title = "Ejemplo", ylabel = "Eje y", colores = [:green, :red])
```
"""
function análisis_gráfico(f::Function, número_iteraciones::Int, x0::Array{N, 1}, a::Real, b::Real, paso::Real, c::Real, d::Real; title::String = "", ylabel::String = "\$f(x)\$", colors::Array) where N <: Real

    #Convirtiendo los elementos de los puntos muestra a flotantes:
    a = float(a)
    b = float(b)
    paso = float(paso)

    #Generando la gráfica de la función:
    rango_x = a:paso:b
    
    título = LaTeXString(title)
    leyenda_y = LaTeXString(ylabel)
    
    gráfica = plot(rango_x, f, 
        xaxis = (L"x", (a, b)),
        yaxis = (leyenda_y, (c, d)),
        legend = false, 
        title = título, 
        grid = false,
        label = "Función iterada")
    
    #Y de la identidad:
    plot!(gráfica, x -> x, color = :red, label = L"Id")
    
    #El eje x:
    plot!(gráfica, x -> 0, color = :orange)
    
    #Generando las gráficas de los iterados
    número_condiciones_iniciales = length(x0)
    
    for i in 1:número_condiciones_iniciales
        
        valor_inicial = float(x0[i])
        color_i = colors[i]
        
        #Cargando los iterados:
        iterados = iteraciones(f, número_iteraciones, valor_inicial)

        #Gráfica de los iterados iniciales:
        x_0 = iterados[1]
        x_1 = iterados[2]

        x_iniciales = [x_0, x_0, x_1]
        y_iniciales = [0, x_1, x_1]

        plot!(gráfica, x_iniciales, y_iniciales, 
            line=(color_i, :path, 2.0, :dot), 
            marker=(:circle, 0.5), 
            label = "x0 = $x_0")

        #Gráfica del resto de los iterados:
        for i in 2:número_iteraciones

            x_actual = iterados[i]
            x_siguiente =  iterados[i+1]

            x = [x_actual, x_actual, x_siguiente]
            y = [x_actual, x_siguiente, x_siguiente]

            plot!(gráfica, x, y, 
                line=(color_i, :path, 2.0, :dot), 
                marker=(:circle, 0.5),
                label = "")
        end
    end
    
    return(gráfica)
end

"""
    función_iterar(f::Function, número_iteraciones::Int)

Devuelve la función "simbólica" proveniente de iterar `f` el `número_iteraciones` dado.

# Argumentos

Requiere:

+ `f`, una función, y,
+ `número_iteraciones`, un entero que dicta el número de iteraciones a realizar.

# Ejemplo
```julia-repl

julia> f = x -> x^2 - 1; g = función_iterar(f, 2); g(1)
-1

julia> f = x -> x^2 - 1; g = función_iterar(f, 2); g(0)
0
```
"""
function función_iterar(f::Function, número_iteraciones::Int)
    
    if número_iteraciones == 1
        
        return(f)
        
    else
        
        return(x -> f(función_iterar(f, número_iteraciones - 1)(x)))
            
    end
end

#Exporta las funciones al entorno global:

export iteraciones
export iterar
export análisis_gráfico
export función_iterar

end