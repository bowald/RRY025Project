%%

% Constants

cut   = 10;  % Grey/tolarance. Higher, a smaler spectra of grey values.
% c     = 1;
Yh    = 1.2; % > 1  %Brightness higher is darker
Yl    = [0.7:0.1:0.9]; % < 1 %lower makes black areas more black

% forestgray = im2double(imread('pout.tif'));
load('forest.mat');
figure
  imshow(forestgray, []) % Original image
n = size(forestgray,1);
m = size(forestgray,2);
q = 2*m - 1;
p = 2*n - 1;
% log
forest = log(forestgray);

figure
  % imshow(forest, []); % Logarithm of the image

% Zero padding
forest = padarray( forest , [p-n q-m],  0, 'post');   

% Transform
forest = fft2(forest);                                

% Shift
forest = fftshift(forest);                            
  
  % Setup D(x,y)
  [u, v] = meshgrid(1:q,1:p);
  centerU = ceil(q/2);
  centerV = ceil(p/2);

for i = 1:length(Yl)
  gaussianNumerator = ((u - centerU).^2 + (v - centerV).^2);
  H = 1 - exp( - (gaussianNumerator./ (2* cut.^2) ) );
  H = (Yh - Yl(i)) * H + Yh;
  % figure
  % imshow(H,[]);
    %The filtering
    procForest = H.*forest;

    % Shift
    procForest = ifftshift(procForest);

    % I-Transform
    procForest = ifft2(procForest);

    % Crop
    procForest = procForest(1:n, 1:m);

    % Inverse log
    procForest = exp(procForest); %reverse log(x + 1)

    % Result only in real values
    result = real(procForest);

    figure
    imshow(result,[])
end