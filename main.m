%%
load('forest.mat');

% init functions
forest = log(1 + forestgray);
forest = fft2(forest);

% Build H(u,v)
rforest = raduv(forest); %helper function for geting the distance from u and v.

% Constants
cut   = [2:9];
c     = 10;
Yh    = 1.2; % > 1
Yl    = 0.25; % < 1

% % Homomorphic filter
results = {};
for i = 1:length(cut)
    H = (Yh - Yl) .* (1 - exp(-c *(rforest.^2 ./ (cut(i)^2) ) ) ) + Yl;

    %The filtering
    procForest = H.*forest;

    %Reverse transform and save in array
    procForest = ifft2(procForest);
    procForest = exp(procForest) - 1; %reverse log(x + 1)
    results{1,i} = real(procForest);
end

% Display images neatly
displayImageGrid(results,cut);




%imshow([forestgray, results{2}],[])

% read 4.7.3
% Check lecture IMAGE ENHANCMENT IV
% Zero padding
% Centering FFTWShift