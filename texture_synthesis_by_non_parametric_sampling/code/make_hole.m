%give input as a .gif/.jpg image and get it padded along border and
%saved as .gif

% user specified prameters begin
padding_size = 25; % on each direction
is_gif = 0; % 1 if input is .gif, 0 if input is .jpg
image_path = '../data/color_5.jpg'; % give relative path to input image
imagefilename = '../data/hole_4.gif'; % relative path to store final image after making hole along border as .gif
% user specified paramters end

if is_gif == 1
    [original, map] = imread(image_path);
    original = ind2rgb(original, map);
else
original = imread(image_path);
original = double(original);
original = original/255;
end

original = padarray(original, [padding_size, padding_size], 0);

[imind,cm] = rgb2ind(original,256);

imwrite(imind,cm,imagefilename,'gif', 'Loopcount',inf);