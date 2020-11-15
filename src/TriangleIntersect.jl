module TriangleIntersect

import Base: convert, intersect
using LinearAlgebra: cross, dot, norm, normalize
using GeometryBasics: Point, Vec, Triangle, decompose

export IntersectableTriangle, Ray, Intersection, no_intersection

# 3 dimensions
const D = 3;

struct IntersectableTriangle
    a::Point{D}
    v1::Point{D}
    v2::Point{D}
    normal::Vec{D}
    v1v1::Float64
    v2v2::Float64
    v1v2::Float64
    denom::Float64
    function IntersectableTriangle(a::Point{D}, b::Point{D}, c::Point{D})
        v1 = b - a
        v2 = c - a
        normal = cross(v1, v2)
        v1v1 = dot(v1, v1)
        v2v2 = dot(v2, v2)
        v1v2 = dot(v1, v2)
        denom = v1v2 * v1v2 - v1v1 * v2v2
        new(a, v1, v2, normal, v1v1, v2v2, v1v2, denom)
    end
end

convert(::Type{IntersectableTriangle}, t::Triangle) = IntersectableTriangle(decompose(Point, t)...)

struct Ray
    origin::Point{D}
    direction::Vec{D}
    Ray(a, b) = new(a, normalize(b))
end

struct Intersection
    ip::Point{D} # intersecting point
    id::Float64 # intersecting distance
    is_intersection::Bool
end

const no_intersection = Intersection(Point(0, 0, 0), 0.0, false)

function intersect(r::Ray, t::IntersectableTriangle)
    denom = dot(t.normal, r.direction)
    denom == 0 && return no_intersection
    ri = dot(t.normal, (t.a - r.origin)) / denom
    ri <= 0 && return no_intersection
    plane_intersection =  ri * r.direction + r.origin
    w = plane_intersection - t.a
    wv1 = dot(w, t.v1)
    wv2 = dot(w, t.v2)
    s_intersection = (t.v1v2 * wv2 - t.v2v2 * wv1) / t.denom
    s_intersection <= 0 && return no_intersection
    s_intersection >= 1 && return no_intersection
    t_intersection = (t.v1v2 * wv1 - t.v1v1 * wv2) / t.denom
    t_intersection <= 0 && return no_intersection
    t_intersection >= 1 && return no_intersection
    s_intersection + t_intersection >= 1 && return no_intersection
    Intersection(t.a + s_intersection * t.v1 + t_intersection * t.v2, ri, true)
end

intersect(r::Ray, t::Triangle{D}) = intersect(r, convert(IntersectableTriangle, t))

end # module
