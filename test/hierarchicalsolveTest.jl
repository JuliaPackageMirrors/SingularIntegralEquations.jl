#
# test hierarchicalsolve
#
using ApproxFun, SingularIntegralEquations, Base.Test

M = 50
L = Array(LowRankMatrix{Float64},14)
[L[i] = LowRankMatrix(0.001rand(4M,2),0.001rand(4M,2)) for i=1:2]
[L[i] = LowRankMatrix(0.01rand(2M,2),0.01rand(2M,2)) for i=[3:4;9:10]]
[L[i] = LowRankMatrix(0.1rand(M,2),0.1rand(M,2)) for i=[5:8;11:14]]
D = Array(Diagonal{Float64},8)
[D[i] = Diagonal(1./collect(1:M)) for i=1:8]

H = HierarchicalMatrix(D,L)

@test rank(H) == 400
#@test blockrank(H) == fill(2,8,8)+diagm(fill(48,8))
@test isfactored(H) == false

B = Array(Vector{Float64},8)
[B[i] = rand(M) for i=1:8]
b = rand(size(H,1))#HierarchicalVector(B)

full(H)\b
@time x = full(H)\b
H\b # includes compile time
H = HierarchicalMatrix(D,L)
@time xw = H\b # includes precomputation
@time xw = H\b # H.A's precomputed and factored :)

@test isfactored(H) == true

CH = cond(H)

@test norm(x-xw) ≤ 10CH^2*eps()
@test norm(H*x-b) ≤ 10CH*eps()
@test norm(H*xw-b) ≤ 10CH*eps()


H+H-(H-H)
@test norm(full(H-H)) < 10norm(full(H))*eps()



# Hierarchical operators case

i = 2

dom = cantor(Interval(),i)
⨍ = DefiniteLineIntegral(dom)
f = Fun(x->logabs(x-5im),dom)
sp = Space(dom)

G = GreensFun((x,y)->1/2,CauchyWeight(sp⊗sp,0);method=:Cholesky)

@time u1 = ⨍[G]\transpose(f)
println("Adaptive QR  forward error norm is: ",norm(⨍[G]*u1-f))

@test norm(⨍[G]*u1-f) < 10eps()

hdom = clustertree(dom)
hsp = Space(hdom)

G1 = GreensFun((x,y)->1/2,CauchyWeight(hsp⊗hsp,0);method=:Cholesky)
H = ⨍[G1]

@time u2 = H\f
@time u2 = H\f

@test condest(H) ≤ 20.0

import ApproxFun: ∞
@test blockrank(H) == Number[∞ 8 9 9; 8 ∞ 9 9; 9 9 ∞ 8; 9 9 8 ∞]

println("The hierarchical forward error norm is: ",norm(⨍[G]*u2-f))

@test norm(⨍[G]*u2-f) < 10eps()



# Test three domains

dom = Interval(-2.0,-1.0+0im)∪Interval(1.0,2.0+0im)∪Interval(-0.5-2im,0.5-2im)
hdom = clustertree(dom)
dom = UnionDomain(SingularIntegralEquations.collectdata(hdom))
⨍ = DefiniteLineIntegral(dom)
f = Fun(x->logabs(x-5im),dom)
sp = Space(dom)

G = GreensFun((x,y)->1/2,CauchyWeight(sp⊗sp,0);method=:Cholesky)

@time u1 = ⨍[G]\transpose(f)

println("Adaptive QR  forward error norm is: ",norm(⨍[G]*u1-f))

@test norm(⨍[G]*u1-f) < 300eps()

if VERSION ≥ v"0.5pre"
    warn("Skipping test in 0.5 due to error in type inference due to #265")
else
    hsp = Space(hdom)

    G1 = GreensFun((x,y)->1/2,CauchyWeight(hsp⊗hsp,0);method=:Cholesky)
    H = ⨍[G1]

    @time u2 = H\f
    @time u2 = H\f

    println("The hierarchical forward error norm is: ",norm(⨍[G]*u2-f))

    @test norm(⨍[G]*u2-f) < 10000eps()
end
