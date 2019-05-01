function hrir = interpolateHRIR(hrir_in, gain, p)
% apply VBAP gain to combine the HRIR inputs
    hrir = zeros(200, 1);
    hrir = hrir + gain(1) * squeeze(hrir_in(p(1), p(3), :));
    hrir = hrir + gain(2) * squeeze(hrir_in(p(1), p(4), :));
    hrir = hrir + gain(3) * squeeze(hrir_in(p(2), p(3), :));
    hrir = hrir + gain(4) * squeeze(hrir_in(p(2), p(4), :));
end
