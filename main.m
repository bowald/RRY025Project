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
cut   = [2:9];
c     = 10;
Yh    = 2; % > 1
Yl    = 0.25; % < 1

% % Homomorphic filter
results = {};
for i = 1:length(cut)
    H = (Yh - Yl) .* (1 - exp(-c *(rforest.^2 ./ (cut(i)^2) ) ) ) + Yl;
    procForest = H.*forest;
    procForest = ifft2(procForest);
    procForest = exp(procForest);
    results{1,i} = procForest;
end

% Display images neatly
displayImageGrid(results,cut);




%imshow([forestgray, results{5}],[])