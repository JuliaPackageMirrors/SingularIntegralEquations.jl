# Fractals
# TODO: fat Cantor sets, Smith-Volterra-Cantor sets, asymmetric Cantor sets...

export cantor, thincantor, thinnercantor, thinnestcantor

# α is width, n is number of levels

# Standard Cantor set removes the middle third at every level
cantor{T}(d::Domain{T},n::Int) = cantor(d,n,3)

function cantor{T}(d::Interval{T},n::Int,α::Number)
    a,b = d.a,d.b
    if n == 0
        return d
    else
        d = Interval{T}(zero(T),one(T))
        C = d/α ∪ (α-1+d)/α
        for k=2:n
            C = C/α ∪ (α-1+C)/α
        end
        return a+(b-a)*C
    end
end

# Thin Cantor set removes the middle n/(n+2)th at the nth level

thincantor{T}(d::Domain{T},n::Int) = thincantor(d,n,3)

function thincantor{T}(d::Interval{T},n::Int,α::Number)
    a,b = d.a,d.b
    if n == 0
        return d
    else
        d = Interval{T}(zero(T),one(T))
        C = d/(α+n-1) ∪ (α+n-2+d)/(α+n-1)
        for k=n-1:-1:1
            C = C/(α+k-1) ∪ (α+k-2+C)/(α+k-1)
        end
        return a+(b-a)*C
    end
end

thinnercantor{T}(d::Domain{T},n::Int) = thinnercantor(d,n,3)

function thinnercantor{T}(d::Interval{T},n::Int,α::Number)
    a,b = d.a,d.b
    if n == 0
        return d
    else
        d = Interval{T}(zero(T),one(T))
        C = d/α^n ∪ (α^n-1+d)/α^n
        for k=n-1:-1:1
            C = C/α^k ∪ (α^k-1+C)/α^k
        end
        return a+(b-a)*C
    end
end

thinnestcantor{T}(d::Domain{T},n::Int) = thinnestcantor(d,n,3)

function thinnestcantor{T}(d::Interval{T},n::Int,α::Number)
    a,b = d.a,d.b
    if n == 0
        return d
    else
        d = Interval{T}(zero(T),one(T))
        C = d/α^(2^(n-1)) ∪ (α^(2^(n-1))-1+d)/α^(2^(n-1))
        for k=n-1:-1:1
            C = C/α^(2^(k-1)) ∪ (α^(2^(k-1))-1+C)/α^(2^(k-1))
        end
        return a+(b-a)*C
    end
end

function cantor{T,V}(d::Circle{T,V},n::Int,α::Number)
    c,r = d.center,d.radius
    α = convert(promote_type(real(T),V,typeof(α)),α)
    if n == 0
        return d
    else
        C = cantor(Interval{T}(),n,α)
        return UnionDomain(map(d->Arc(c,r,(d.a+1/2α)π,(d.b+1/2α)π),C[1:div(length(C),2)])) ∪ UnionDomain(map(d->Arc(c,r,(d.a-1/2α)π,(d.b-1/2α)π),C[div(length(C),2)+1:length(C)]))
    end
end
