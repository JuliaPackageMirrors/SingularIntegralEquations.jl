module SIE
    using Base, ApproxFun

export cauchy, hilbert, hilbertinverse, cauchyintegral
import ApproxFun
import ApproxFun: PeriodicDomain, BandedShiftOperator, bandinds, dirichlettransform, idirichlettransform!, Curve,CurveSpace, OpenCurveSpace, ClosedCurveSpace,transform,SpaceOperator, rangespace, domainspace, addentries!, BandedOperator, PeriodicDomainSpace, AnySpace, canonicalspace, domain, promotedomainspace, AnyDomain, CalculusOperator,SumSpace,PiecewiseSpace, interlace,Multiplication,VectorDomainSpace


function cauchy(s::Integer,f,z)
    @assert abs(s) == 1
    
    cauchy(s==1,f,z)
end


include("Hilbert.jl")
include("Cauchy.jl")


include("circlecauchy.jl")
include("periodiclinecauchy.jl")
include("intervalcauchy.jl")
include("singfuncauchy.jl")

include("vectorcauchy.jl")

end #module


