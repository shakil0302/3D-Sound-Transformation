function [az, el, dis] = interpolateLocation(kp, azk, elk, disk, fp, method)
% this function interpolate source location at current frame from keyframe data
    az = interp1(kp, azk, fp, method);
    el = interp1(kp, elk, fp, method);
    dis = interp1(kp, disk, fp, method);
end
