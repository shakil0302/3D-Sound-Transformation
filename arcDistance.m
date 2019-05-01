function dis = arcDistance(p1, p2)
% calculate spherical distance between points
    dis = abs(acos( cos(p1(1)) * cos(p2(1)) + sin(p1(1)) * sin(p2(1)) * cos(p1(2)-p2(2))));
end
