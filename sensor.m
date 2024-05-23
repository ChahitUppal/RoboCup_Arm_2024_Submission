% Define the topic names
pointCloudTopic = '/camera/depth/points';
rgbTopic = '/camera/rgb/image_raw';

% Create subscribers
pcSub = rossubscriber(pointCloudTopic, 'sensor_msgs/PointCloud2');
rgbSub = rossubscriber(rgbTopic, 'sensor_msgs/Image');

% Wait for messages to be received
disp('Waiting for messages from the point cloud and RGB image topics...');
pcMsg = receive(pcSub, 10); % Wait up to 10 seconds for a message
rgbMsg = receive(rgbSub, 10); % Wait up to 10 seconds for a message

% Check if messages were received
if isempty(pcMsg) || isempty(rgbMsg)
    error('Failed to receive messages from the point cloud or RGB image topics.');
end

% Extract point cloud data
ptCloudMsg = readXYZ(pcMsg, 'PreserveStructureOnRead', true);

% Extract RGB image data
rgbImageMsg = readImage(rgbMsg, 'PreserveStructureOnRead', true);

% Check if point cloud data is valid
if isempty(ptCloudMsg)
    error('No valid point cloud data received.');
end

% Convert point cloud data to double
ptCloudData = double(ptCloudMsg);

% Create a point cloud object
ptCloud = pointCloud(ptCloudData);

% Visualize the point cloud
figure;
pcshow(ptCloud);
title('Point Cloud');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');

% Visualize the depth sensor
figure;
subplot(1, 2, 1);
imshow(rgbImageMsg);
title('RGB Image');

subplot(1, 2, 2);
depthImage = sqrt(sum(ptCloud.Location.^2, 3)); % Calculate depth from point cloud
imagesc(depthImage);
title('Depth Sensor');
axis equal;
colormap('jet');
colorbar;

disp('Point cloud and depth sensor displayed.');
