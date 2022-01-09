function [isoglcm] = isoGLCM(img, G, d)
% isoGLCM calculates the isometric GLCM (Gray Level Coocurrence Matrices) 
% of an image. The result is normalized and symmetric.

isoglcm = zeros(G);
thetas = [0, 45, 90, -45];

for t = 1:length(thetas)
    isoglcm = isoglcm + GLCM(img, G, d, thetas(t));
end

isoglcm = isoglcm/3;
end
    