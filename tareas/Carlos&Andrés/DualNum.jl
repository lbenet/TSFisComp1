
module DualNum

struct Dual
    x  :: Float64
    x´ :: Float64
end

Dual(c::Real) = Dual(c,0.0)

dual(x0::Real)=Dual(x0,1.0)


#Importamos la definición de los siguientes operadores
import Base:+,-,*,/,^

+(u::Dual,v::Dual)=Dual(u.x+v.x,u.x´+v.x´)

-(u::Dual,v::Dual)=Dual(u.x-v.x, u.x´-v.x´)

*(u::Dual,v::Dual)=Dual( u.x * v.x, u.x´*v.x + u.x*v.x´)

function /(u::Dual , v::Dual)
    y = u.x / v.x
    Dual(y, (u.x´ - y * v.x´)/v.x)
end

function ^(a::Dual , n::Int)
    y = a.x^(n-1)
    Dual(a.x * y , n*y*a.x´)
end

#Extenderemos la operación +
+(a::Real, u::Dual) = Dual(a + u.x, u.x´)
+(u::Dual,a::Real) = Dual(a+u.x,u.x´)

#Extenderemos la operación -
-(a::Real,u::Dual) = Dual(a - u.x, -u.x´)
-(u::Dual,a::Real) = Dual(u.x - a, u.x´)

#Extenderemos la operación *
*(a::Real, u::Dual) = Dual(a*u.x , a*u.x´)
*(u::Dual, a::Real) = Dual(a*u.x , a*u.x´)

#Extenderemos la operación /
function /(a::Real,u::Dual)
    Dual(a/u.x , -a*u.x´/u.x^2)
end

/(u::Dual, a::Real) = u*a^(-1)

import Base: show

function Base.show(io::IO, d::Dual)
    if d.x´>= 0
        println("$(d.x) + $(d.x´) ϵ")
    else
        println("$(d.x) $(d.x´) ϵ")
    end
end

import Base: sqrt, exp, log, sin, cos, sinh, cosh

sqrt(u::Dual) = Dual(sqrt(u.x), u.x´/(2*sqrt(u.x)))

exp(u::Dual) = Dual(exp(u.x), u.x´*exp(u.x))

log(u::Dual) = Dual(log(u.x), u.x´/u.x)

sin(u::Dual) = Dual(sin(u.x), u.x´*cos(u.x))

cos(u::Dual) = Dual(cos(u.x), -u.x´*sin(u.x))

sinh(u::Dual) = Dual(sinh(u.x), u.x´*cosh(u.x))

cosh(u::Dual) = Dual(cosh(u.x), u.x´*sinh(u.x))

export +, -, *, /, ^, sqrt, exp, log, sin, cos, sinh, cosh, Dual, dual

end
