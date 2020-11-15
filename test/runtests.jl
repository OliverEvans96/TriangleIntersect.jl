using GeometryBasics
using TriangleIntersect
using Test

a = Point(0,0,0)
b = Point(1,0,0)
c = Point(0,1,0)
t = Triangle(a,b,c)

#=
         45° .
           ⟋ |
s = d√2  ⟋   |
       ⟋     | d
     ⟋       |
45°⟋_________|
        d

Fig. 1: Diagram of a 45-45-90 triangle.

This is a top view.
The top corner is (x0, y0, 0), the vertical projection of the initial point (x0, y0, z0) onto the triange t
The hypotenuse is the path of the ray as viewed from above.
The bottom left corner is the intersection point of the ray and triangle.
=#

#=
    . 30°
    |\
    | \
    |  \  2s
s√3 |   \
    |    \
    |_____\ 60°
       s

Fig. 2: Diagram of a 30-60-90 triangle.

This is a side view.
The top corner is the initial point (x0, y0, z0).
The bottom side is the same as the hypotenuse of Fig. 1
The intersection distance is the length of the hypotenuse.
=#

d = 0.1
s = √2d
(x0, y0, z0) = (d, d, √3s)
# Scale the Vec just to make sure normalization is working.
r = Ray(Point(x0, y0, z0), .12345 * Vec(d, d, -√3s))
@test intersect(r, t) == Intersection(Point(x0 + d, y0 + d, 0), 2s, true)

# yeah, more tests are needed :)


