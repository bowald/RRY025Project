%%

% Constants

cut   = [40:10:80];
c     = 1;
Yh    = 2; % > 1
Yl    = 0.75; % < 1

forestgray = im2double(imread('pout.tif'));
%load('forest.mat');
imshow(forestgray)
n = size(forestgray,1);
m = size(forestgray,2);
q = 2*m - 1;
p = 2*n - 1;
% log
forest = log(1 + forestgray);                         

% Zero padding
forest = padarray( forest , [p-n q-m],  'replicate', 'post');   

% Transform
forest = fft2(forest);                                

% Shift
forest = fftshift(forest);                            
  
  % Setup D(x,y)
  [u, v] = meshgrid(1:q,1:p);
  centerU = ceil(q/2);
  centerV = ceil(p/2);

for i = 1:length(cut)
  gaussianNumerator = ((u - centerU).^2 + (v - centerV).^2);
  H = 1 - exp(-c * (gaussianNumerator./(cut(i).^2)));
  H = (Yh - Yl) * H + Yh;

    %The filtering
    procForest = H.*forest;

    % Shift
    procForest = ifftshift(procForest);

    % I-Transform
    procForest = ifft2(procForest);

    % Crop
    procForest = procForest(1:n, 1:m);

    % Inverse log
    procForest = exp(procForest - 1); %reverse log(x + 1)

    % Result only in real values
    result = real(procForest);

    figure
    imshow(result,[])
end