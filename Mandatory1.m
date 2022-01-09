clear all;
close all;

% Reading images
mosaic1 = imread('mosaic1.png');
mosaic2 = imread('mosaic2.png');

% Normalizing the images
G = 2^4; % grayscale levels
mosaic1 = histeq(mosaic1, G);
mosaic1 = uint8(round(double(mosaic1)*(G - 1)/double(max(mosaic1(:)))));
mosaic2 = histeq(mosaic2, G);
mosaic2 = uint8(round(double(mosaic2)*(G - 1)/double(max(mosaic2(:)))));

% Splitting mosaics into separate textures
[N,M] = size(mosaic1);
t1a = mosaic1(1:N/2, 1:M/2);
t1b = mosaic1(1:N/2, M/2+1:M);
t1c = mosaic1(N/2+1:N, 1:M/2);
t1d = mosaic1(N/2+1:N, M/2+1:M);
t2a = mosaic2(1:N/2, 1:M/2);
t2b = mosaic2(1:N/2, M/2+1:M);
t2c = mosaic2(N/2+1:N, 1:M/2);
t2d = mosaic2(N/2+1:N, M/2+1:M);

% Visualizing the textures for mosaic 1
d = 3; % delta
theta = -45; % angle
v1a = GLCM(t1a, G, d, theta);
v1b = GLCM(t1b, G, d, theta);
v1c = GLCM(t1c, G, d, theta);
v1d = GLCM(t1d, G, d, theta);

figure(1);
colormap parula
subplot(2, 2, 1);
imagesc(v1a), colorbar, title('GLCM texture a');
subplot(2, 2, 2);
imagesc(v1b), colorbar, title('GLCM texture b');
subplot(2, 2, 3);
imagesc(v1c), colorbar, title('GLCM texture c');
subplot(2, 2, 4);
imagesc(v1d), colorbar, title('GLCM texture d');

% Visualizing the textures for mosaic 2
d = 4; % delta
theta = 90; % angle
v2a = isoGLCM(t2a, G, d);
v2b = isoGLCM(t2b, G, d);
v2c = isoGLCM(t2c, G, d);
v2d = isoGLCM(t2d, G, d);

figure(2);
colormap parula
subplot(2, 2, 1);
imagesc(v2a), colorbar, title('GLCM texture a');
subplot(2, 2, 2);
imagesc(v2b), colorbar, title('GLCM texture b');
subplot(2, 2, 3);
imagesc(v2c), colorbar, title('GLCM texture c');
subplot(2, 2, 4);
imagesc(v2d), colorbar, title('GLCM texture d');

% Getting the feature images
windowSize = 31;
[IDM1, INR1, SHD1] = glidingGLCM(mosaic1, G, 3, -45, windowSize, 0);
[IDM2, INR2, SHD2] = glidingGLCM(mosaic2, G, 4, 90, windowSize, 1);

figure(3)
colormap jet
subplot(1,3,1)
imagesc(IDM1), colorbar, title('GLCM homogeneity');
subplot(1,3,2)
imagesc(INR1), colorbar, title('GLCM inertia');
subplot(1,3,3)
imagesc(SHD1), colorbar, title('GLCM cluster shade');

figure(4)
colormap jet
subplot(1,3,1)
imagesc(IDM2), colorbar, title('GLCM homogeneity');
subplot(1,3,2)
imagesc(INR2), colorbar, title('GLCM inertia');
subplot(1,3,3)
imagesc(SHD2), colorbar, title('GLCM cluster shade');

% Applying global threshold to the feature images
figure(5)
colormap gray
subplot(2,2,1)
imagesc(IDM1), title('GLCM inertia');
subplot(2,2,2)
imagesc(INR1.*(INR1 <= 39 & INR1 >= 23)), title('Threshold: 27 < T < 39');
subplot(2,2,3)
imagesc(INR1.*(INR1 <= 20)), title('Threshold: 0 < T < 20');
subplot(2,2,4)
imagesc(INR1.*(INR1 <= 65 & INR1 >= 40)), title('Threshold: 40 < T < 65');

figure(6)
colormap gray
subplot(1,3,1)
imagesc(SHD1), title('GLCM cluster shade');
subplot(1,3,2)
imagesc(SHD1.*(SHD1 <= -0.4*10^5)), title('Threshold: T < -0.4*10^5');
subplot(1,3,3)
imagesc(SHD1.*(SHD1 >= -0.38*10^5)), title('Threshold: -0.39*10^5 < T');


figure(12)
colormap gray
subplot(1,3,1)
imagesc(SHD2), title('GLCM cluster shade');
subplot(1,3,2)
imagesc(SHD2.*uint8(SHD2 <= -0.8*10^6)), title('Threshold: 0 < T < -0.8*10^6')
subplot(1,3,3)
imagesc(mosaic2.*uint8(SHD2 <= -0.8*10^6)), title('Threshold image')

figure(11)
colormap gray
subplot(1,3,1)
imagesc(IDM2), title('GLCM homogeneity');
subplot(1,3,2)
imagesc(IDM2.*(IDM2 <= 0.22)), title('Threshold: 0 < T < 0.22');
subplot(1,3,3)
imagesc(mosaic2.*uint8(IDM2 <= 0.22)), title('Threshold image');

figure(14)
colormap gray
subplot(1,3,1)
imagesc(INR2), title('GLCM inertia');
subplot(1,3,2)
imagesc(INR2.*(INR2 >= 52 & IDM2 >= 0.23)), title('Threshold: 0 < T < 45 - texture a');
subplot(1,3,3)
imagesc(mosaic2.*uint8(INR2 >= 52 & IDM2 >= 0.23)), title('Threshold image');

figure(13)
colormap gray
subplot(1,3,1)
imagesc(INR2), title('GLCM inertia');
subplot(1,3,2)
imagesc(INR2.*(INR2 <= 45 & SHD2 >= -0.79*10^6)), title('Threshold: 0 < T < 45 - texture b');
subplot(1,3,3)
imagesc(mosaic2.*uint8(INR2 <= 45 & SHD2 >= -0.79*10^6)), title('Threshold image');