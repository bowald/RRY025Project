%%
load('forest.mat');

% init functions
forest = log(forestgray);
forest = fft2(forest);

% Build H(u,v)
type raduv.m
rforest = raduv(forest);

% Constants
n     = 1;
cut   = 80;
c     = 1;
Yh    = 2; % > 1
Yl    = 0.25; % < 1

% % Homomorphic filter
H = (Yh - Yl) .* (1 - exp(-c *(rforest.^2 ./ (cut^2) ) ) ) + Yl;

procForest = H.*forest;

% % reverse functions
procForest = ifft2(procForest);
procForest = exp(procForest);





% % padcam = padarray(cam,[1 1],'both');
% % freqIm = fft2(padcam);
% % freqIm = fftshift(freqIm);

imshow([forestgray, real(procForest)],[])