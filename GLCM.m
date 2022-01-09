function [glcm] = GLCM(img, G, d, theta)
% GLCM calculates the GLCM (Gray Level Coocurrence Matrices) of an image.
% The result is normalized and symmetric.

[N,M] = size(img);
glcm = zeros(G);

% Translating input
if theta == 0
    dx = d;
    dy = 0;
elseif theta == 45
    dx = d;
    dy = d;
elseif theta == 90
    dx = 0;
    dy = d;
elseif theta == -45
    dx = d;
    dy = d;
    img = flipud(img);
end

% Counting transitions
for i = 1:N
    for j = 1:M
        % Indexing
        if i + dy > N || i + dy < 1 || i + dx < 1 || ...
           j + dx > M || j + dy < 1 || j + dx < 1
           continue
        end
        first = img(i,j);
        second = img(i + dy, j + dx);
        glcm(first + 1, second + 1) = glcm(first + 1, second + 1) + 1;
    end
end

% Make symmetric
glcm = glcm + glcm';

% Normalize
glcm = glcm/sum(sum(glcm));
end