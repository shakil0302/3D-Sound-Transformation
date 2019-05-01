%% 3D sound information
% this section will contain information about mono audio
% and set up how the audio source will move in 3D space.

% the file must be single a channel audio
[mono fs] = audioread('piano_mono.wav');

% the keyframes contains information about location about some
% specific times. here, the entire length is divided in range [0-1]
% azimuth and elevation is in degree with interaural-polar coordinate
% system. distance is in meter.
% the missing points will be inter/extrapolate
keypoint = [0 .1 .2 .3 .4 .6 .7 .9 1];
azimuth_key = [65 -25 46 53 -36 62 53 -23 12];
elevation_key = [230 90 230 90 230 90 230 90 230];
distance_key = [2 3 4 10 5 6 3 2 5];

% create a visual graph which show how these values will be interpolated.
graph_interval = 0:0.001:1;
[az_graph, el_graph, dis_graph] = interpolateLocation(keypoint, azimuth_key,...
       elevation_key, distance_key, graph_interval, 'spline');
subplot(2, 2, 1);
plot(graph_interval, az_graph), title('Azimuth Variations');
subplot(2, 2, 2);
plot(graph_interval, el_graph), title('Elevation Variations');
subplot(2, 2, 3);
plot(graph_interval, dis_graph), title('Distance Variations');

%% invoke tranformation
res = transform3D(mono, fs, keypoint, azimuth_key, elevation_key, distance_key);

%% play result
% There is no problem in understanding the azimuth change. elevation is
% slightly harder to preceive but works well in front, back and top and
% many other locations. this is due to the fact that we constantly moves
% our head to understad spatial location. the head movement detection needs
% special hardware hence left off from the current implementation.
sound(res, fs);
pause;
clear sound;

%% write output file
audiowrite('piano_3d.ogg', res, fs);
