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

^(x::Dual, y::T) where T<:Real = Dual(^(x.x, y), x.x´*y*^(x.x, y - 1))

#Algunas funciones trascendentes:

import Base: sqrt, exp, log

sqrt(u::Dual) = begin
   
    raíz = sqrt(u.x)
    valor = Dual(raíz, u.x´ / (2*raíz))
    
    return(valor)
end

exp(u::Dual) = begin
   
    exponencial = exp(u.x)
    valor = Dual(exponencial, u.x´*exponencial)
    
    return(valor)
end

log(u::Dual) = begin
   
    valor = Dual(log(u.x), u.x´/u.x)
    
    return(valor)
end

log(b::Real, x::Dual) = log(x)/log(b)

#Funciones trigonométricas y sus inversas:

import Base: sin, cos, tan, cot, sec, csc

sin(x::Dual) = Dual(sin(x.x),  x.x'*cos(x,x))
cos(x::Dual) = Dual(cos(x.x), -x.x'*sin(x,x))
tan(x::Dual) = Dual(tan(x.x),  x.x´*sec(x.x)^2)
cot(x::Dual) = Dual(cot(x.x), -x.x´*csc(x.x)^2)
sec(x::Dual) = Dual(sec(x.x),  x.x'*sec(x.x)*tan(x.x))
csc(x::Dual) = Dual(csc(x.x), -x.x'*csc(x.x)*cot(x.x))

import Base: asin, acos, atan, acot, asec, acsc

asin(x::Dual) = Dual(asin(x.x),  x.x'/sqrt(1 - x.x^2))
acos(x::Dual) = Dual(acos(x.x), -x.x'/sqrt(1 - x.x^2))
atan(x::Dual) = Dual(atan(x.x),  x.x´/(1 + x.x^2))
acot(x::Dual) = Dual(acot(x.x), -x.x´/(1 + x.x^2))
asec(x::Dual) = Dual(asec(x.x),  x.x'/(abs(x.x)*sqrt(x.x^2 - 1)))
acsc(x::Dual) = Dual(acsc(x.x), -x.x'/(abs(x.x)*sqrt(x.x^2 - 1)))

#Funciones hiperbólicas y sus inversas:

import Base: sinh, cosh, tanh, coth, sech, csch

sinh(x::Dual) = Dual(sinh(x.x), x.x'*cosh(x,x))
cosh(x::Dual) = Dual(cosh(x.x), x.x'*sinh(x,x))
tanh(x::Dual) = Dual(tanh(x.x), x.x´*sech(x.x)^2)
coth(x::Dual) = Dual(coth(x.x), -x.x´*csch(x.x)^2)
sech(x::Dual) = Dual(sech(x.x), -x.x'*sech(x.x)*tanh(x.x))
csch(x::Dual) = Dual(csch(x.x), -x.x'*csch(x.x)*coth(x.x))

import Base: asinh, acosh, atanh, acoth, asech, acsch

asinh(x::Dual) = Dual(asinh(x.x), x.x'*log(x.x + sqrt(x.x^2 + 1)))
acosh(x::Dual) = Dual(acosh(x.x), x.x'*log(x.x + sqrt(x.x^2 - 1)))
atanh(x::Dual) = Dual(atanh(x.x), x.x´*log((1 + x.x)/(1 - x.x))/2)
acoth(x::Dual) = Dual(acoth(x.x), x.x´*log((x.x + 1)/(x.x - 1))/2)
asech(x::Dual) = Dual(asech(x.x), x.x'*log((1 + sqrt(1 - x.x^2))/x.x))
acsch(x::Dual) = Dual(acsch(x.x), x.x'*log((1 + sqrt(1 + x.x^2))/x.x))

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

export show, Dual, dual
export +, -, *, /, ^
export sqrt, exp, log
export sin, cos, tan, cot, sec, csc
export asin, acos, atan, acot, asec, acsc
export sinh, cosh, tanh, coth, sech, csch
export asinh, acosh, atanh, acoth, asech, acsch
export derivada_dual

end