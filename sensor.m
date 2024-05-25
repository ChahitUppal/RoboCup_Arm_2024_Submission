% Subscribe to the color and depth image topics
colorImageSub = rossubscriber('/camera/rgb/image_raw');
depthImageSub = rossubscriber('/camera/depth/image_raw');

% Create figures for display
colorFig = figure('Name', 'Color Image');
depthFig = figure('Name', '3D Depth Visualization');

% Initialize tick step size
tickStep = 50;

% Loop to continuously receive and visualize images
while true
    % Receive the color image
    try
        colorMsg = receive(colorImageSub, 10); % Timeout after 10 seconds
        colorImage = readImage(colorMsg);
        
        % Update the color image display
        figure(colorFig);
        imshow(colorImage);
        title('Color Image');
        
        % Add dynamic axis with variable tick spacing
        axis on;
        [height, width, ~] = size(colorImage);
        xlim([0.5, width + 0.5]);
        ylim([0.5, height + 0.5]);
        
        % Determine tick spacing based on tickStep
        xLim = get(gca, 'XLim');
        yLim = get(gca, 'YLim');
        xTickSpacing = tickStep * diff(xLim) / width;
        yTickSpacing = tickStep * diff(yLim) / height;
        
        % Set dynamic ticks
        xTicks = round(xLim(1)):xTickSpacing:round(xLim(2));
        yTicks = round(yLim(1)):yTickSpacing:round(yLim(2));
        set(gca, 'XTick', xTicks, 'YTick', yTicks);
        grid on;
        
        xlabel('X');
        ylabel('Y');
    catch ME
        disp('Error receiving or displaying RGB image:');
        disp(ME.message);
    end

    % Receive the depth image
    try
        depthMsg = receive(depthImageSub, 10); % Timeout after 10 seconds
        depthImage = readImage(depthMsg);
        
        % Convert the depth image to double for visualization
        depthData = double(depthImage);
        
        % Negate the depth data for correct axis display
        depthData = -depthData;
        
        % Create a 3D surface plot with RGB texture
        figure(depthFig);
        clf(depthFig); % Clear current figure
        [X, Y] = meshgrid(1:size(depthData, 2), 1:size(depthData, 1));
        Y=-Y;
        surf(X, Y, depthData, 'FaceColor', 'texturemap', 'CData', colorImage, 'EdgeColor', 'none');
        colormap('jet'); % Apply color map
        colorbar; % Display color bar
        title('3D Depth Visualization with RGB Texturing');
        xlabel('X');
        ylabel('Y');
        zlabel('Depth');
        view(3); % Set the view to 3D
        axis tight;
        shading interp; % Interpolate shading for smoother visualization
    catch ME
        disp('Error receiving or displaying Depth image:');
        disp(ME.message);
    end
    
    drawnow; % Update figures
end
