module AutoDiff

using RecipesBase

struct Dual
    x::Float64
    x′::Float64
end

Dual(c::Real) = Dual(c, 0.)
dual(x₀::Real) = Dual(x₀, 1.)

import Base: show

function show(io::IO, u::Dual)
    u.x′ >= 0 ? print(io, u.x,"+",u.x′,"ε"): print(io, u.x, u.x′,"ε")
end

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

"""
    deriva(f::Function, x0::Real)
Devuelve la derivada de la función `f` evaluada en `x0` con ayuda de
los números duales.
"""
function deriva(f, x₀)
    x = dual(x₀)
    f(x).x′
end


@recipe function f(D::Dual, rangox=linspace(0,4,100))

end

end
