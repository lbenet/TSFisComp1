
module Billar

using Plots

norma(x) = sqrt(x[1]^2+x[2]^2)



function trayectoria(x,y,dx,dy,a,b,ra,rebotes)
    
    Θ = 0:0.0001:2*pi

    C1x = []
    C1y = []

    C2x = []
    C2y = []

    for θ in Θ
        push!(C1x,ra + a*cos(θ))
        push!(C1y,a*sin(θ))
        push!(C2x,b*cos(θ))
        push!(C2y,b*sin(θ))
    end
    
    r = [x,y]
    
    v = [dx,dy]    
    v = [dx,dy]*(b-a)/(norma(v)*500)
    
    velocidad = norma(v)
    
    R1 = norma(r-[ra,0])
    R2 = norma(r)
    
    X = []
    Y = []
    
    push!(X,x)
    push!(Y,y)
    
    P = []
    THETA = []
        
    for i in 1:rebotes
    
        while R1 > a && R2 < b  
        
            x = x + v[1]
            push!(X,x)
        
            y = y + v[2]
            push!(Y,y)
            
            R1 = norma([x,y]-[ra,0])
            R2 = norma([x,y])
    
        end
        
        if R1 <= a 
                   
            pop!(X)
            pop!(Y)
            
            tgx = [Y[end],-(X[end]-ra)]
            
            θ = acos((v[1]*tgx[1] + v[2]*tgx[2])/(norma(tgx)*velocidad))
            
            Rot = [cos(2*θ) -sin(2*θ); sin(2*θ) cos(2*θ)]
            
            v = Rot*v
            
            x = X[end] + v[1]
            push!(X,x)
            
            y = Y[end] + v[2]
            push!(Y,y)
                        
            R1 = norma([x,y]-[ra,0])
            R2 = norma([x,y])
            
            if Y[end-1] < 0 && (X[end-1]-ra) > 0
                
                β = atan(Y[end-1]/(X[end-1]-ra)) + 2*pi
                p = a*β
            
                push!(P,p)
                push!(THETA,θ)
                
            end
            
            if Y[end-1] > 0 && (X[end-1]-ra) < 0
                
                β = atan(Y[end-1]/(X[end-1]-ra)) + pi
                p = a*β
            
                push!(P,p)
                push!(THETA,θ)
                
            end
            
            if Y[end-1] > 0 && (X[end-1]-ra) > 0
                
                β = atan(Y[end-1]/(X[end-1]-ra))
                p = a*β
            
                push!(P,p)
                push!(THETA,θ)
                
            end
            
            if Y[end-1] < 0 && (X[end-1]-ra) < 0
                
                β = atan(Y[end-1]/(X[end-1]-ra)) + pi
                p = a*β
            
                push!(P,p)
                push!(THETA,θ)
                
            end
            
        end
        
        if R2 >= b
            
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
                        
            R1 = norma([x,y]-[ra,0])
            R2 = norma([x,y])
            
        end
        
    end
    
    return X,Y,C1x,C1y,C2x,C2y,P,THETA
    
end



function tray_pos(xo,yrange,dx,dy,a,b,ra,rebotes,)
    
    A = []
    
    for yo in yrange
        push!(A,trayectoria(xo,yo,dx,dy,a,b,ra,rebotes))
    end
    
    return A
    
end



function tray_vel(xo,yo,dx,dyrange,a,b,ra,rebotes)
    
    A = []
    
    for dy in dyrange
        push!(A,trayectoria(xo,yo,dx,dy,a,b,ra,rebotes))
    end
    
    return A
    
end



function plot_trayectoria(A)
    
    P1 = plot(A[1][1],A[1][2],legend=false,title="Trayectoria Billar")
    plot!(A[1][3],A[1][4])
    plot!(A[1][5],A[1][6])
    for i in 2:length(A)
        plot!(A[i][1],A[i][2])
    end
    
    return P1
    
end    



function plot_ángulos(A)
    
    P2 = scatter(A[1][7],A[1][8],legend=false,xlabel="Perímetro",ylabel="ángulo")
    for i in 2:length(A)
        scatter!(A[i][7],A[i][8])
    end
    
    return P2
    
end

end
