img = imread('example.png');

% Upscale image to 500 px height
[height, width, ~] = size(img);
scaling_factor = 500/height;
img_resized = imresize(img, scaling_factor);

% Canny edge detection
img_gray = rgb2gray(img_resized);
edges = edge(img_gray, 'canny');

% Erase margin
edges(1:20,:) = 0; % top
edges(end-19:end,:) = 0; % bottom
edges(:,1:20) = 0; % left
edges(:,end-19:end) = 0; % right

% Find contour
[B,L] = bwboundaries(edges, 'noholes');

% Cell array holds the boundary coordinates
boundary_cell = cell(length(B), 1);

for k = 1:length(B)
    boundary = B{k};
    boundary_matrix = zeros(length(boundary), 2);
    for i = 1:length(boundary)
        boundary_matrix(i, :) = [boundary(i, 2), boundary(i, 1)];
    end
    boundary_cell{k} = boundary_matrix;
end

% Display 
figure;
subplot(1,2,1);
imshow(img);
title('Original Image');
subplot(1,2,2);
imshow(edges);
hold on;
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2);
end
title('Boundary');

% Save to file
save('boundary_cell.mat', 'boundary_cell');
