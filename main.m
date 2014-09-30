%%
load('forest.mat');

% init functions
imshow(forestgray)
% forest = histeq(forestgray);
% figure
% imshow(forest,[])
forest = log(1 + forestgray);
% med padding skall bilden vara 601 x 893
n = 301;
m = 447;
q = 2*m - 1;
p = 2*n - 1;

forest = padarray( forest , [p-n q-m],  0, 'post');
forest = fft2(forest);
forest = fftshift(forest);

% Build H(u,v)
rforest = raduv(forest); %helper function for geting the distance from u and v.

% Constants
cut   = [40:10:80];
c     = 1;
Yh    = 2; % > 1
Yl    = 0.25; % < 1

% % Homomorphic filter
for i = 1:length(cut)
    H = (Yh - Yl) .* (1 - exp(-c *(rforest.^2 ./ (cut(i)^2) ) ) ) + Yl;

    %The filtering
    procForest = forest.*H;
    procForest = ifftshift(procForest);
    procForest = ifft2(procForest);
    procForest = procForest(1:n, 1:m);
    procForest = exp(procForest) - 1; %reverse log(x + 1)
    result = real(procForest);

    figure
    imshow(result,[])
end

% Display images neatly
% displayImageGrid(results,cut);

%imshow([forestgray, results{2}],[])

% read 4.7.3
% Check lecture IMAGE ENHANCMENT IV
% Zero padding
% Centering FFTWShift