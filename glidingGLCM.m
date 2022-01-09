function [IDM, INR, SHD] = glidingGLCM(img, G, d, theta, w_s, iso)
% Calculate the GLCM for every glading window in an image. It adds a frame
% to the image first so that the resulting image is the same size as input.
% iso : 1 for isometric GLCM, 0 otherwise

[M_o, N_o] = size(img); % Original image size
h_s = floor(w_s/2); % Size of half the filter

% Apply the zero-padding to the original image
imgPadded = zeros(M_o + w_s - 1, N_o + w_s - 1);
imgPadded(h_s:end - h_s - 1, h_s:end - h_s - 1) = img;

[M, N] = size(imgPadded); % Padded image size

% Index matrices
i = repmat((0:(G - 1))', 1, G);
j = repmat(0:(G - 1), G, 1);

% Buffers for resulting images
IDM = zeros(M_o, N_o);
INR = zeros(M_o, N_o);
SHD = zeros(M_o, N_o);

% Go through the image
for m = (h_s + 1):(M - h_s - 1)
    for n = (h_s + 1):(N - h_s - 1)
        
        % Extracting the window
        window = imgPadded(m - h_s:m + h_s, ...
            n - h_s:n + h_s);
        
        % Calculating the GLCM
        if iso == 1
            p = isoGLCM(window, G, d);
        else
            p = GLCM(window, G, d, theta);
        end
        
        % Calculating the homogeneity, IDM (Inverse Difference Moment)
        IDM(m - h_s, n - h_s) = sum(sum((1./(1 + (i - j).^2).*p)));
        
        % Calculating the inertia, INR
        INR(m - h_s, n - h_s) = sum(sum(((i - j).^2).*p));
        
        % Calculating the cluster shade, SHD
        ux = sum(sum(p.*(i + 1)));
        uy = sum(sum(p.*(j + 1)));
        SHD(m - h_s, n - h_s) = sum(sum((i + j - ux - uy).^3));
    end
end
end