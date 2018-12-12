
module DS

using DynamicalSystems

function norma(x)
    
    return sqrt(x[1]^2+x[2]^2)
    
end

function Billiard(x,p,n)       #x[1]=x x[2] = y x[3] = dx  x[4] = dy     #p[1] = a, p[2] = b, p[3]=ra
    
    r = [x[1],x[2]]
    
    v = [x[3],x[4]]    
    v = [x[3],x[4]]*(p[2]-p[1])/(norma(v)*500.0)
    
    velocidad = norma(v)
    
    R1 = norma(r-[p[3],0.0])
    R2 = norma(r)
    
    x1 = [0.0,0.0]
    x2 = [0.0,0.0]
    
    if R1 > p[1] && R2 < p[2]  
        
        x1[1] = x[1] + v[1]
        
        x1[2] = x[2] + v[2]
            
        R1 = norma([x1[1],x1[2]]-[p[3],0.0])
        R2 = norma([x1[1],x1[2]])
    
    end
    
    if R1 <= p[1] 
        
        x2[1] = x[1] - v[1]
        
        x2[2] = x[2] - v[2]
                             
        tgx = [x2[2],-(x2[1]-p[3])]
            
        θ = acos((v[1]*tgx[1] + v[2]*tgx[2])/(norma(tgx)*velocidad))
            
        Rot = [cos(2.0*θ) -sin(2.0*θ); sin(2.0*θ) cos(2.0*θ)]
            
        v = Rot*v
            
        x1[1] = x2[1] + v[1]
                   
        x1[2] = x2[2] + v[2]
                                
        R1 = norma([x1[1],x1[2]]-[p[3],0.0])
        R2 = norma([x1[1],x1[2]])
    end
    
    if R2 >= p[2]
        
        x2[1] = x[1] - v[1]
        
        x2[2] = x[2] - v[2]
                              
        tgx = [x2[2],-x2[1]]
            
        θ = acos((v[1]*tgx[1] + v[2]*tgx[2])/(norma(tgx)*velocidad))
            
        Rot = [cos(2.0*θ) sin(2.0*θ); -sin(2.0*θ) cos(2.0*θ)]
            
        v = Rot*v
            
        x1[1] = x2[1] + v[1]
            
        x1[2] = x2[2] + v[2]
                                    
        R1 = norma([x1[1],x1[2]]-[p[3],0.0])
        R2 = norma([x1[1],x1[2]])
            
    end
    
    return SVector{4}(x1[1],x1[2],v[1],v[2])
    
end

function Jacobiano(x,p,n)
    
    r = [x[1],x[2]]
    
    v = [x[3],x[4]]    
    v = [x[3],x[4]]*(p[2]-p[1])/(norma(v)*500.0)
    
    velocidad = norma(v)
    
    R1 = norma(r-[p[3],0.0])
    R2 = norma(r)
    
    if R1 > p[1] && R2 < p[2]  
        
        J = @SMatrix[1.0 0.0 1.0 0.0; 0.0 1.0 0.0 1.0; 0.0 0.0 1.0 0.0; 0.0 0.0 0.0 1.0]
        
    end
    
    if R1 <= p[1]
        
        f = (v[1]*(x[2]-v[2]) - v[2]*(x[1]-v[1]-p[3]) )/(p[1]*velocidad)
    
        dfx1 = -v[2]/(p[1]*velocidad)
        
        dfx2 = v[1]/(p[1]*velocidad)
        
        dfv1 = x[2]/(p[1]*velocidad)
        
        dfv2 = -(x[1]-p[3])/(p[1]*velocidad)
        
        θ = acos(f)
    
        dacos = 1.0/(sqrt(1.0-f^2))
        
        
        
        dR1x1 = 1 + 2*f*v[1]*dfx1 + 2*v[1]*sin(θ)*f*dacos*dfx1 + 2*v[2]*dfx1*(-f^2*dacos + sin(θ))
        
        dR1x2 = 2*f*v[1]*dfx2 + 2*v[1]*sin(θ)*f*dacos*dfx2 + 2*v[2]*dfx2*(-f^2*dacos + sin(θ))
        
        dR2x1 = 2*f*v[2]*dfx1 + 2*v[2]*sin(θ)*f*dacos*dfx1 - 2*v[1]*dfx1*(-f^2*dacos + sin(θ))
        
        dR2x2 = 1 + 2*f*v[2]*dfx2 + 2*v[2]*sin(θ)*f*dacos*dfx2 - 2*v[1]*dfx2*(-f^2*dacos + sin(θ))
        
        dR1v1 = -1 + 2*f*dfv1*v[1] + f^2 + 2*sin(θ)*f*dacos*dfv1*v[1]-(sin(θ))^2 + 2*v[2]*dfv1*(-f^2*dacos+sin(θ))
        
        dR1v2 = 2*f*dfv2*v[1] + 2*sin(θ)*f*dacos*dfv2*v[1] + 2*v[2]*dfv2*(-f^2*dacos+sin(θ)) + 2*sin(θ)*f
        
        dR2v1 = 2*f*dfv1*v[2] + 2*sin(θ)*f*dacos*dfv1*v[2] - 2*v[1]*dfv1*(-f^2*dacos+sin(θ)) - 2*sin(θ)*f
        
        dR2v2 = -1 + 2*f*dfv2*v[2] + f^2 + 2*sin(θ)*f*dacos*dfv2*v[2]-(sin(θ))^2 + 2*v[1]*dfv2*(-f^2*dacos+sin(θ))
        
        dv1x1 = dR1x1 - 1
        
        dv1x2 = dR1x2
        
        dv2x1 = dR2x1       
        
        dv2x2 = dR2x2 - 1
        
        dv1v1 = dR1v1 +1
        
        dv1v2 = dR1v2
        
        dv2v1 = dR2v1
        
        dv2v2 = dR2v2 +1
        
        J = @SMatrix[ dR1x1  dR1x2 dR1v1 dR1v2; dR2x1  dR2x2 dR2v1 dR2v2; dv1x1 dv1x2 dv1v1 dv1v2; dv2x1 dv2x2 dv2v1 dv2v2  ]
        
    end
    
    
    
    if R2 >= p[2]
        
        f = (v[1]*(x[2]-v[2]) - v[2]*(x[1]-v[1]) )/(p[2]*velocidad)
    
        θ = acos(f)
        
        dfx1 = -v[2]/(p[2]*velocidad)
        
        dfx2 = v[1]/(p[2]*velocidad)
        
        dfv1 = x[2]/(p[2]*velocidad)
        
        dfv2 = -x[1]/(p[2]*velocidad)
        
        dacos = 1.0/(sqrt(1-f^2))
        
        
        dR1x1 = 1 +2.0*f*dfx1*v[1] + 2.0*v[1]*sin(θ)*f*dacos*dfx1 + 2.0*v[2]*dfx1*(-f^2*dacos+sin(θ))
        
        dR1x2 = 2.0*v[1]*f*dfx2 + 2.0*v[1]*sin(θ)*f*dacos*dfx2 + 2.0*v[2]*dfx2*(-f^2*dacos + sin(θ))
        
        dR2x1 = 2*f*dfx1*v[2] + 2*v[2]sin(θ)*f*dacos*dfx1 - 2*v[1]*dfx1*(-f^2*dacos+sin(θ))
        
        dR2x2 = 1 + 2*f*dfx2*v[2] + 2*v[2]*sin(θ)*f*dacos*dfx2 - 2*v[1]*dfx2*(-f^2*dacos+sin(θ))
        
        dR1v1 = -1 + 2*f*dfv1*v[1] + f^2 + 2*sin(θ)*f*dacos*dfv1*v[1]-(sin(θ))^2 + 2*v[2]*dfv1*(-f^2*dacos+sin(θ))
        
        dR1v2 = 2*f*dfv2*v[1] + 2*sin(θ)*f*dacos*dfv2*v[1] + 2*v[2]*dfv2*(-f^2*dacos+sin(θ)) + 2*sin(θ)*f
        
        dR2v1 = 2*f*dfv1*v[2] + 2*sin(θ)*f*dacos*dfv1*v[2] - 2*v[1]*dfv1*(-f^2*dacos+sin(θ)) - 2*sin(θ)*f
        
        dR2v2 = -1 + 2*f*dfv2*v[2] + f^2 + 2*sin(θ)*f*dacos*dfv2*v[2]-(sin(θ))^2 + 2*v[1]*dfv2*(-f^2*dacos+sin(θ))
        
        dv1x1 = dR1x1 - 1
        
        dv1x2 = dR1x2
        
        dv2x1 = dR2x1       
        
        dv2x2 = dR2x2 - 1
        
        dv1v1 = dR1v1 +1
        
        dv1v2 = dR1v2
        
        dv2v1 = dR2v1
        
        dv2v2 = dR2v2 +1
        
        J = @SMatrix[ dR1x1  dR1x2 dR1v1 dR1v2; dR2x1  dR2x2  dR2v1  dR2v2;  dv1x1 dv1x2 dv1v1 dv1v2; dv2x1 dv2x2 dv2v1 dv2v2 ]
        
    end
    
    return J
    
end

end
