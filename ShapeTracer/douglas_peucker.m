function simplified = douglas_peucker(points, tolerance)
    % DOUGLAS_PEUCKER: Simplify a 2D polyline using the Douglas-Peucker algorithm
    %   points: a n x 2 matrix of (x,y) coordinates representing the polyline
    %   tolerance: the maximum distance between the simplified polyline and the original
    %
    %   Returns a m x 2 matrix of (x,y) coordinates representing the simplified polyline.
    
    % Calculate the squared distances between each point and the line segment defined by the first and last point
    segment = [points(1,:); points(end,:)];
    distances = point_to_segment_distance(points, segment);
    
    % Find the point with the maximum distance from the line segment
    [max_distance, max_index] = max(distances);
    
    % If the maximum distance is less than the tolerance, return the endpoints of the line segment
    if max_distance <= tolerance
        simplified = segment;
    else
        % Otherwise, recursively simplify the two line segments split by the point with the maximum distance
        left_points = points(1:max_index,:);
        left_simplified = douglas_peucker(left_points, tolerance);
        right_points = points(max_index:end,:);
        right_simplified = douglas_peucker(right_points, tolerance);
        
        % Combine the simplified line segments
        simplified = [left_simplified(1:end-1,:); right_simplified];
    end
end

function distances = point_to_segment_distance(points, segment)
    % POINT_TO_SEGMENT_DISTANCE: Calculate the squared distances between each point and a line segment
    %   points: a n x 2 matrix of (x,y) coordinates representing the points
    %   segment: a 2 x 2 matrix of (x,y) coordinates representing the endpoints of the line segment
    %
    %   Returns a n x 1 vector of squared distances from each point to the line segment.
    
    % Compute the normalized direction vector of the line segment
    direction = segment(2,:) - segment(1,:);
    direction = direction / norm(direction);
    
    % Compute the projection of each point onto the line segment
    to_segment = points - segment(1,:);
    projection = dot(to_segment, direction, 2) * direction;
    closest_point = segment(1,:) + projection;
    
    % Compute the squared distance between each point and its projection
    distances = sum((points - closest_point).^2, 2);
end
