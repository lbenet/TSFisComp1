module DifAutom

#Definición del tipo Dual.
# *Nota*: Se cambió el nombre del campo "diferencial" a algo que pueda escribir de manera más sencilla, de `  x′ ` a ` x´ ` (el apóstrofe usado).
"""
        Dual

    Definición de los números duales. Los campos internos son:

        x  :: Float64   # valor de la función
        x´ :: Float64   # valor de su derivada

"""
struct Dual
    x  :: Float64
    x´ :: Float64
end

# Sobrecarga la función `show` para mostrar los duales en la notación "usual"

function Base.show(io::IO, u::Dual)

    if (u.x´ < 0) | (u.x´ == -0.0)
        
        print(io, "$(u.x) - $(abs(u.x´)) ε")
        
    else
        
        print(io, "$(u.x) + $(u.x´) ε")
    end
end

# Funciones que convierten un real en un dual con cierto campo `x´`

Dual(c::Real) = Dual(c, 0.0)

dual(x0::Real) = Dual(x0, 1.0)

# Extensión de algunas funciones básicas para operar con el tipo `Dual`

import Base: +, -, *, /, ^

+(u::Dual, v::Dual) = Dual( u.x + v.x, u.x´ + v.x´)
+(a::Real, b::Dual) = Dual(a + b.x, b.x´)
+(a::Dual, b::Real) = Dual(a.x + b, a.x´)

-(u::Dual, v::Dual) = Dual( u.x - v.x, u.x´ - v.x´)
-(a::Real, b::Dual) = Dual(a - b.x, b.x´)
-(a::Dual, b::Real) = Dual(a.x - b, a.x´)

*(u::Dual, v::Dual) = Dual( u.x * v.x, u.x * v.x´ + u.x´ * v.x)
*(a::Real, b::Dual) = Dual(a * b.x, a * b.x´)
*(a::Dual, b::Real) = Dual(a.x * b, a.x´ * b)

function /(u::Dual, v::Dual)
    y = u.x / v.x
    Dual( y, (u.x´ - y * v.x´)/v.x )
end
/(a::Real, b::Dual) = Dual(a / b.x, (- (a/b.x) * b.x´)/b.x)
/(a::Dual, b::Real) = Dual(a.x / b, a.x´/b)


function ^(a::Dual, n::Int)
    y = a.x^(n-1)
    Dual(a.x * y, n*y*a.x´)
end

import Base.sqrt

sqrt(u::Dual) = begin
   
    raíz = sqrt(u.x)
    valor = Dual(raíz, u.x´ / (2*raíz))
    
    return(valor)
end

import Base.exp

exp(u::Dual) = begin
   
    exponencial = exp(u.x)
    valor = Dual(exponencial, u.x´*exponencial)
    
    return(valor)
end

import Base.log

log(u::Dual) = begin
   
    valor = Dual(log(u.x), u.x´/u.x)
    
    return(valor)
end

import Base.sin

sin(u::Dual) = begin
    
    valor = Dual(sin(u.x), u.x´*cos(u.x))
    return(valor)
end   

import Base.cos

cos(u::Dual) = begin
    
    valor = Dual(cos(u.x), -u.x´*sin(u.x))
    return(valor)
end  

import Base.sinh

sinh(u::Dual) = begin
    
    valor = Dual(sinh(u.x), u.x´*cosh(u.x))
    return(valor)
end   

import Base.cosh

cosh(u::Dual) = begin
    
    valor = Dual(cosh(u.x), u.x´*sinh(u.x))
    return(valor)
end

"""
    derivada_dual(f, x0)

La función `derivada_dual` calcula la derivada numérica de la función `f` en el punto `x0` usando números duales.

# Argumentos

La función requiere que `f` sea una función definida para duales y que `x0` sea un número real.

# Ejemplos
´´´julia-repl
julia> derivada_dual(x -> x, 1)
1.0

julia> derivada_dual(x -> x^2, 1)
2.0
´´´
"""
function derivada_dual(f::Function, x0::Real)
    
    derivada_x0 = f(dual(x0)).x´
    
    return(derivada_x0)
end

#Exportando las funciones al entorno global:

export show
export Dual
export dual
export +
export -
export *
export /
export ^
export sqrt
export exp
export log
export sin
export cos
export sinh
export cosh
export derivada_dual

end