function [ai, aj, ei, ej] = findQuad(az, el, az_r, el_r)
% find four nearest points of azimuth and elevation
    
    % calculate azimuth locations
    if az <= -80
       ai = 1;
       aj = 1;
    elseif az >= 80
       ai = 25;
       aj = 25;
    else
        for i=1:24
           if az_r(i) <= az && az_r(i+1) >= az
              ai = i;
              aj = i+1;
           end
        end
    end
    
    % calculate elevation locations
    if el > 230.625
       ei = 1;
       ej = 50;
    else
        for i=1:49
           if el_r(i) <= el && el_r(i+1) >= el
              ei = i;
              ej = i+1;
           end
        end
    end
end
