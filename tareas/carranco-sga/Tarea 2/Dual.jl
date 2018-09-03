# La definición del tipo `Dual`. 
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

# Funciones que convierten un real en un dual con cierto campo `x´`

Dual(c::Real) = Dual(c, 0.0)

dual(x0::Real) = Dual(x0, 1.0)

# Extensión de algunas funciones básicas para operar con el tipo `Dual`

+(u::Dual, v::Dual) = Dual( u.x + v.x, u.x´ + v.x´)

-(u::Dual, v::Dual) = Dual( u.x - v.x, u.x´ - v.x´)

*(u::Dual, v::Dual) = Dual( u.x * v.x, u.x * v.x´ + u.x´ * v.x)

function /(u::Dual, v::Dual)
    y = u.x / v.x
    Dual( y, (u.x´ - y * v.x´)/v.x )
end

function ^(a::Dual, n::Int)
    y = a.x^(n-1)
    Dual(a.x * y, n*y*a.x´)
end

print("Cargado el tipo `Dual` así como algunas operaciones con este tipo.")
