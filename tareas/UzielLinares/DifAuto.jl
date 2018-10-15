# Defino un tipo parametrico
struct Dual{T, K}
    x::T
    x′::K
end

Dual(c::Real) = Dual(c, 0.)
dual(x0::Real) = Dual(x0, 1.)

import Base:show

function show(io::IO, u::Dual)
    u.x′ > 0 ? print(u.x,"+",u.x′,"ε"): print(u.x, u.x′,"ε")
end


# Se extienden los operadores
import Base: +, -, *, /, ^
+(u::Dual, v::Dual) = Dual(u.x + v.x, u.x′ + v.x′)
-(u::Dual, v::Dual) = Dual(u.x - v.x, u.x′ - v.x′)
*(u::Dual, v::Dual) = Dual( u.x * v.x, u.x * v.x′ + u.x′ * v.x)

function /(u::Dual, v::Dual)
    y = u.x / v.x
    Dual( y, (u.x′ - y * v.x′)/v.x )
end

function ^(u::Dual, n::Int)
    y = u.x^(n-1)
    Dual(u.x^n, n * y * u.x′)
end

+(a::Real, u::Dual) = Dual(a + u.x, u.x′)
+(u::Dual, a::Real) = Dual(a + u.x, u.x′)

-(a::Real, u::Dual) = Dual(a - u.x, u.x′)
-(u::Dual, a::Real) = Dual(u.x - a, u.x′)

*(a::Real, u::Dual) = Dual(a * u.x, u.x′ * a)
*(u::Dual, a::Real) = Dual(a * u.x, u.x′ * a)

/(a::Real, u::Dual) = Dual(a / u.x, -((a / u.x)*u.x′) / u.x)
/(u::Dual, a::Real) = Dual(u.x / a, u.x′ / a)


import Base: sqrt, exp, log, sin, cos, sinh, cosh
sin(u::Dual) = Dual(sin(u.x), u.x′ * cos(u.x))
cos(u::Dual) = Dual(cos(u.x), -u.x′ * sin(u.x))
exp(u::Dual) = Dual(exp(u.x), u.x′ * exp(u.x))
log(u::Dual) = Dual(log(u.x), u.x′ / u.x)
sinh(u::Dual) = Dual(sinh(u.x), u.x′ * cosh(u.x))
cosh(u::Dual) = Dual(cosh(u.x), u.x′ * sinh(u.x))


"""doc
    deriva(f::Function, x0::Real)
Devuelve la derivada de la función `f` evaluada en `x0` con ayuda de los números duales.
"""
function deriva(f, x0)
    x = dual(x0)
    f(x).x′
end
