function [az, el, dis] = normalizeLocation(az, el, dis)
% az and el must be within range of the coordinate system
% distance wont be negative.
    dis = abs(dis)+.01;
    
    % transform az into [-90 90] range
    az = mod(az, 360);
    az = az - (az > 180) * 360;
    if az > 90
       az = 180-az; 
    end
    if az < -90
       az = -180-az;
    end
    
    % transform elevation into [-45 315]
    el = mod(el, 360);
    if el >= 315
       el = el-360; 
    end
end
