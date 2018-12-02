
module Billar

using Plots

norma(x) = sqrt(x[1]^2+x[2]^2)



function trayectoria(x,y,dx,dy,a,b,rebotes)
    
    Θ = 0:0.0001:2*pi

    C1x = []
    C1y = []

    C2x = []
    C2y = []

    for θ in Θ
        push!(C1x,a*cos(θ))
        push!(C1y,a*sin(θ))
        push!(C2x,b*cos(θ))
        push!(C2y,b*sin(θ))
    end
    
    r = [x,y]
    
    v = [dx,dy]    
    v = [dx,dy]*(b-a)/(norma(v)*5000)
    
    velocidad = norma(v)
    
    R = norma(r)
    
    X = []
    Y = []
    
    push!(X,x)
    push!(Y,y)
        
    for i in 1:rebotes
    
        while R > a && R < b  
        
            x = x + v[1]
            push!(X,x)
        
            y = y + v[2]
            push!(Y,y)
            
            R = sqrt(x^2+y^2)
    
        end
        
        if R <= a 
                   
            pop!(X)
            pop!(Y)
            
            tgx = [Y[end],-X[end]]
            
            θ = acos((v[1]*tgx[1] + v[2]*tgx[2])/(norma(tgx)*velocidad))
            
            Rot = [cos(2*θ) -sin(2*θ); sin(2*θ) cos(2*θ)]
            
            v = Rot*v
            
            x = X[end] + v[1]
            push!(X,x)
            
            y = Y[end] + v[2]
            push!(Y,y)
                        
            R = sqrt(x^2+y^2)
            
        end
        
        if R >= b
            
           pop!(X)
            pop!(Y)
            
            tgx = [Y[end],-X[end]]
            
            θ = acos((v[1]*tgx[1] + v[2]*tgx[2])/(norma(tgx)*velocidad))
            
            Rot = [cos(2*θ) sin(2*θ); -sin(2*θ) cos(2*θ)]
            
            v = Rot*v
            
            x = X[end] + v[1]
            push!(X,x)
            
            y = Y[end] + v[2]
            push!(Y,y)
                        
            R = sqrt(x^2+y^2)
            
        end
        
    end
    
    return X,Y,C1x,C1y,C2x,C2y
end



function tray_pos(xo,yrange,dx,dy,a,b,rebotes,)
    
    A = []
    
    for yo in yrange
        push!(A,trayectoria(xo,yo,dx,dy,a,b,rebotes))
    end
    
    return A
    
end



function tray_vel(xo,yo,dx,dyrange,a,b,rebotes)
    
    A = []
    
    for dy in dyrange
        push!(A,trayectoria(xo,yo,dx,dy,a,b,rebotes))
    end
    
    return A
    
end



function gráfica(A)
    
    P1 = plot(A[1][1],A[1][2],legend=false)
    plot!(A[1][3],A[1][4])
    plot!(A[1][5],A[1][6])
    for i in 2:length(A)
        plot!(A[i][1],A[i][2])
    end
    
    return P1
    
end    

end
