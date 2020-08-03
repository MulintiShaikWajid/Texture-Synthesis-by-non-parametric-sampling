function generated = hf_gray(original, window_size, filled, filename)

% hole filling for gray scale, hole in black colour

% window size must be odd
% final_rows and final_width specify the dimensions of required generated texture

inf_1 = 100;
inf_2 = 10000;
epsilon = 0.1;
max_distance = 0.03;
sigma = window_size/6.4;

half_window = floor(window_size/2);
gray = original;
gray = double(gray);
gray = gray/255;
[original_rows,original_columns] = size(gray);

generated = gray;

gray(filled == 0) = inf_1;
initial_filled = filled;
initial_filled = initial_filled(:);

generated = padarray(generated, [half_window, half_window]);
filled = padarray(filled, [half_window, half_window]);

% The image is padded with zeros on all four sides
gray_padded = padarray(gray,[half_window,half_window]);
gray_stacked =  im2col(gray_padded,[window_size,window_size]);

kernel = ones(window_size,window_size);
kernel(half_window+1,half_window+1) = 0;
ind = -half_window:half_window;
[X, Y] = meshgrid(ind,ind);
gaussian = exp(-(X.^2 + Y.^2) / (2*sigma*sigma));
gaussian = gaussian(:);
loop = 0;

while sum(sum(filled(half_window+1:original_rows+half_window,half_window+1:original_columns+half_window)<1))
    loop = loop+1;
    flag = 0;
        neighbours_of_unfilled = (filled(half_window+1:original_rows+half_window,half_window+1:original_columns+half_window) < 1).*conv2(filled(half_window+1:original_rows+half_window,half_window+1:original_columns+half_window),kernel,'same');
        neighbours_of_unfilled = neighbours_of_unfilled(:);
        [values, present] = sort(neighbours_of_unfilled,'descend');       
        for temp = 1:length(present)
            if neighbours_of_unfilled(present(temp)) < 1
                break;
            end
            pos = present(temp);
            [row,column] = ind2sub([original_rows,original_columns],pos);
            row = row + half_window;
            column = column + half_window;
            neighbourhood = generated(row-half_window:row+half_window,column-half_window:column+half_window);
            neighbourhood = neighbourhood(:);
            neighbourhood_filled = filled(row-half_window:row+half_window,column-half_window:column+half_window);
            neighbourhood_filled = neighbourhood_filled(:);            
            norm_factor = sum(neighbourhood_filled.*gaussian);
            distances = (sum((((gray_stacked - neighbourhood).*neighbourhood_filled).^2).*gaussian))/norm_factor;
            distances(initial_filled == 0) = inf_2;
            min_distance = min(distances);
            valid = find(distances<=((1+epsilon)*min_distance));
            random_pick = valid(randi(length(valid)));
            if distances(random_pick) < max_distance
                flag = 1;
                generated(row,column) = gray(random_pick);
                filled(row,column) = 1;
            end
        end
        imshow(uint8(255*generated(half_window+1:original_rows+half_window,half_window+1:original_columns+half_window)));
       if flag < 1
           max_distance = 1.1*max_distance;
       end
       
       [imind,cm] = gray2ind(generated(half_window+1:original_rows+half_window,half_window+1:original_columns+half_window),256);        
       if loop == 1
           imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
       else
           imwrite(imind,cm,filename,'gif','WriteMode','append');
       end       
end

    generated = generated(half_window+1:original_rows+half_window,half_window+1:original_columns+half_window);

end
