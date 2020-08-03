clear;
% user specified prameters begin
window_size = 11; % must be ODD, higher for better image modelling
final_rows = 201; % for texture modelling
final_columns = 201; % for texture modelling
image_path = '../data/gray_2.gif'; % give relative path to input image 
% NOTE: prefer .gif for color images texture modelling and only .gif for color images hole filling
is_gif_and_color = 1; % 1 if input image is color 'and' in .gif format, else 0 
tm = 0; % 1 means texture modelling, 0 means hole filling
filename = '../results/result_gif.gif'; % use .gif only, relative path to store GIF representing the growth of image
imagefilename = '../results/result_2.gif'; % use .gif only, relative path to store FINAL IMAGE after texture modelling or hole filling
% NOTE: hole is identified as a group of connected black pixels
% user specified paramters end


% taking input image into a matrix called original
if is_gif_and_color == 1
    [original, map] = imread(image_path);
    original = ind2rgb(original, map);
    original = uint8(255*original);    
else
original = imread(image_path);
end

[rows, columns, z] = size(original);

global original_padded
global filled


    
    % performing the texture modelling or hole filling
    if tm == 1
        if z > 1 % expected to be 3
            final_image = tm_color(original, window_size, final_rows, final_columns, filename);
        else
            final_image = tm_gray(original, window_size, final_rows, final_columns, filename);
        end
    elseif tm == 0    
        if z == 1
            original_padded = padarray(original,[1,1],255);
            filled = ones(rows+2, columns+2);
            imshow(original);
            title('double click inside the hole');
            [initial_x, initial_y] = getpts; %select a(only one) point inside the hole for hole filling
            detect_hole(uint8(floor(initial_y+1)), uint8(floor(initial_x+1)));
            filled = filled(2:rows+1, 2:columns+1);

            final_image = hf_gray(original, window_size, filled, filename);
        else
            original_padded = padarray(original,[1,1],255);
            filled = ones(rows+2, columns+2);
            imshow(original);
            title('double click inside the hole');
            [initial_x, initial_y] = getpts; %select a(only one) point inside the hole for hole filling
            detect_hole_color(uint8(floor(initial_y+1)), uint8(floor(initial_x+1)));
            filled = filled(2:rows+1, 2:columns+1);
            para_filled = filled;     

            final_image = hf_color(original, window_size, filled, filename);
        end
    end





% saving final image as .gif image
if z == 1
    [imind,cm] = gray2ind(final_image,256);
    imwrite(imind,cm,imagefilename,'gif', 'Loopcount',inf);    
else
    [imind,cm] = rgb2ind(final_image,256);
    imwrite(imind,cm,imagefilename,'gif', 'Loopcount',inf);  
end


