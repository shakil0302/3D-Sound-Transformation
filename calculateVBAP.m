function gain = calculateVBAP(point, quad)
% calculate Vector Based Aplitude Panning gain
    gain = zeros(1, 4);
    for i=1:4
       gain(i) = 1000/(1+arcDistance(point, quad(i, :))^2);
    end
    gain = gain/sum(gain);
end
