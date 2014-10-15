%%
% Constants
close all;
cut   = 6;  % cut-of frequency, steepness and width of the gaussian function.
Yh    = 1; % maximum enhancement of high frequencies.
Yl    = 0.5; % maximum inhibition of low frequencies.

load('forest.mat'); %load input image

% Zero padding constants
n = size(forestgray,1);
m = size(forestgray,2);
q = 2*m - 1;
p = 2*n - 1; 

% log
forest = log(forestgray);

% Zero padding
forest = padarray( forest , [p-n q-m],  0, 'post');   

% Transform
forest = fft2(forest);                                

% Shift
forest = fftshift(forest);                            
  
  % Setup D(x,y), the distance function
  [u, v] = meshgrid(1:q,1:p);
  centerU = ceil(q/2);
  centerV = ceil(p/2);

for i = 1:length(Yl) %cut, yl and yh can be entered as vectors for parameter study.
  gaussianNumerator = ((u - centerU).^2 + (v - centerV).^2);
  H = 1 - exp(-(gaussianNumerator./ (2* cut(i).^2) ) ); % The filter
  H = (Yh(i) - Yl(i)) * H + Yl(i);
  
    %Filtering the image
    procForest = H.*forest;

    % Shift
    procForest = ifftshift(procForest);

    % I-Transform
    procForest = ifft2(procForest);

    % Crop
    procForest = procForest(1:n, 1:m);

    % Inverse log
    procForest = exp(procForest); %inverse log(x)

    % Result only in real values
    result = real(procForest);

    figure
    imshow(result,[])
end