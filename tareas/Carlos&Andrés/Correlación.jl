
module Correlación

using Plots


function μn(A)
    
    μ_x = []
    μ_y = []
    
    M = []

    for i in 1:length(A)
        min = length(A[i][1])
        push!(M,min)
    end

    l = minimum(M)
    
    for j in 1:l
        
        sumx = 0
        sumy = 0
        
        for i in 1:length(A)
        
            sumx = sumx + A[i][1][j]
            sumy = sumy + A[i][2][j]
        
        end
    
        muxj = sumx/length(A)
        muyj = sumy/length(A)
        
        push!(μ_x,muxj)
        push!(μ_y,muyj)
        
    end
    
    return μ_x, μ_y
    
end



function Exy(A)
    
    μ = μn(A)
    
    Exyn = []
    
    M = []

    for i in 1:length(A)
        min = length(A[i][1])
        push!(M,min)
    end
    
    l = minimum(M)
    
    for j in 1:l
    
        sum = 0
    
        for i in 1:length(A)
        
            sum = sum + (A[i][1][j] - μ[1][j])*(A[i][2][j] - μ[2][j])
        
        end
    
        exy = sum/length(A)
    
        push!(Exyn,exy)
        
    end
    
    return Exyn
    
end



function Ex(A)
    
    μ = μn(A)[1]
    
    Exn = []
    
    M = []

    for i in 1:length(A)
        min = length(A[i][1])
        push!(M,min)
    end

    l = minimum(M)
    
    for j in 1:l
        
        sum = 0
        
        for i in 1:length(A)
            
            sum = sum + (A[i][1][j] - μ[j])^2
            
        end
        
        ex = sum/length(A)
        
        push!(Exn,ex)
        
    end
    
    return Exn
    
end



function Ey(A)
    
    μ = μn(A)[2]
    
    Eyn = []
    
    M = []

    for i in 1:length(A)
        min = length(A[i][1])
        push!(M,min)
    end

    l = minimum(M)
    
    for j in 1:l
        
        sum = 0
        
        for i in 1:length(A)
            
            sum = sum + (A[i][2][j] - μ[j])^2
            
        end
        
        ey = sum/length(A)
        
        push!(Eyn,ey)
        
    end
    
    return Eyn
    
end



function corr(A)
    
    EXY = Exy(A)
    EX  = Ex(A)
    EY  = Ey(A)
    
    ρ = []
    
    M = []

    for i in 1:length(A)
        min = length(A[i][1])
        push!(M,min)
    end

    l = minimum(M)
    
    for j in 1:l
        
        ρn = EXY[j]/sqrt(EX[j]*EY[j])
        
        if EXY[j] == 0 && EX[j] == 0 && EY[j] < 1e-4
            
            push!(ρ,1)
            
        else
                  
            push!(ρ,ρn)
            
        end
        
    end
    
    return ρ
    
end



function gráfica_corr(A)
    
    R = corr(A)
    R2 = []
    
    for i in 1:length(R)
        
        r = R[i]^2
        push!(R2,r)
     
    end
    
    time = 1:length(R)
    plot(time,R2,legend=false, xlabel="n", ylabel="coeficiente de correlación", title="Correlación")
    
end

end
