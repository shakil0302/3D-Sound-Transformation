function res = transform3D(mono, fs, keypoint, azimuth_key, elevation_key, distance_key)
    % This function implements the algorith which transform the mono audio to
    % binaural 3D output
    % calculate metadata

    sample_count = size(mono, 1);
    duration = sample_count/fs;
    total_key = size(keypoint, 2);

    % load head related impulse response data

    % this implementation uses CIPIC hrir database for hrir data,
    % subject 165 and 21 was used for small and large pianae
    % there are 25x50 location where HRIR was measured.
    % the missing data will be interpolated
    load 'hrir\large.mat';
    azimuth_record = [-80 -65 -55 -45:5:45 55 65 80];
    elevation_record = -45+5.625*(0:49);
    distance_record = 1;
    hrir_fs = 44100;

    % there are some other measurement given, we dont need them.
    clear OnL OnR name ITD;

    % frame by frame analysis

    % create a buffer to hold the result. the output is binaural.
    res = zeros(sample_count, 2);

    % the duration is critical. less frame duration means more spatial
    % resolution. but, smaller the duration, larger the energy leakage.
    % experimenting with few values show .3 is a good choice.
    frame_duration = .3;
    frame_size = fs*frame_duration;

    % now the actual frame by frame filtering is done. to avoid spectral
    % leakage we used blackman window with 50% overlap.
    for i=1:floor(frame_size/2):sample_count
       j = min(i+frame_size-1, sample_count);

       % extract frame data and apply window
       frame = mono(i:j) .* blackman(j-i+1);

       % the frame will be played through a speaker which is placed at
       % the middle location of the frame. we now want to know the point
       % when it occurs.
       frame_point = (i+frame_size/2)/sample_count;

       % now find the actual location based on the frame point
       [azimuth, elevation, distance] = interpolateLocation(keypoint, azimuth_key,...
           elevation_key, distance_key, frame_point, 'spline');

       % the interpolated location doesn't uses interaural polar coordinate.
       % also, interpolated distance can be zero even negative. hence, a
       % transformation is applied to get there principle values.
       [azimuth, elevation, distance] = normalizeLocation(azimuth, elevation, distance);

       % the CIPIC HRIR is measured in 25*50 fixed locations. But we want to
       % play the sound at some arbritary point. I used Vector Based Amplitude
       % Panning technique. First, the sphere is divided into quads, then the
       % quad where the point is located is found.
       [ai, aj, ei, ej] = findQuad(azimuth, elevation, azimuth_record, elevation_record);

       % then I calculated VBAP gain from each of the four speakers. the method
       % used is trival. the gain ratio for each speaker is 1/(1+r*r) where r
       % is the spherical distance from the point.
       quad = [
           azimuth_record(ai) elevation_record(ei);
           azimuth_record(ai) elevation_record(ej);
           azimuth_record(aj) elevation_record(ei);
           azimuth_record(aj) elevation_record(ej)
           ];
       gain = calculateVBAP([azimuth elevation], quad);

       % each speakers HRIR is them linearly combined with their corresponing
       % gain. This creates a composite HRIR both for left and right ear.
       left_h = interpolateHRIR(hrir_l, gain, [ai aj ei ej]);
       right_h = interpolateHRIR(hrir_r, gain, [ai aj ei ej]);

       % here the actual filtering wents.
       left_out = filter(left_h, 1, frame);
       right_out = filter(right_h, 1, frame);

% sound loses enery as it travels. here the actual damping is done. this
% is a simplified technique. In actual case damping is dependent on
% frequency, air humidity etc.
left_out = damp(left_out, distance);
right_out = damp(right_out, distance);

       % the data is saved along with their overlap.
       res(i:j, 1) = res(i:j, 1) + left_out;
       res(i:j, 2) = res(i:j, 2) + right_out;
    end
end
