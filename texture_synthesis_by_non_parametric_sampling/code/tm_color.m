function output = tm_color(original, window_size, final_rows, final_columns, filename)

% window size must be odd
% final_rows and final_width specify the dimensions of required generated texture

epsilon = 0.1;
max_distance = 0.3;
sigma = window_size/6.4;

gray = original;
output = zeros(final_rows,final_columns,3);
half_window = floor(window_size/2);
gray = double(gray);
gray = gray/255;
gray_1 = gray(:,:,1);
gray_2 = gray(:,:,2);
gray_3 = gray(:,:,3);
[gray_rows,gray_columns] = size(gray_1);

% The image is padded with zeros on all four sides
gray_padded_1 = padarray(gray_1,[half_window,half_window]);
gray_stacked_1 =  im2col(gray_padded_1,[window_size,window_size]);
gray_padded_2 = padarray(gray_2,[half_window,half_window]);
gray_stacked_2 =  im2col(gray_padded_2,[window_size,window_size]);
gray_padded_3 = padarray(gray_3,[half_window,half_window]);
gray_stacked_3 =  im2col(gray_padded_3,[window_size,window_size]);
gray_stacked = [gray_stacked_1;gray_stacked_2;gray_stacked_3];

generated_1 = zeros(final_rows+2*half_window,final_columns+2*half_window);
generated_2 = generated_1;
generated_3 = generated_2;
filled = generated_1;

start_r = randi([1,gray_rows-2],1,1);
start_c = randi([1,gray_columns-2],1,1);
generated_1(half_window+ceil(final_rows/2)-1:half_window+ceil(final_rows/2)+1,half_window+ceil(final_columns/2)-1:half_window+ceil(final_columns/2)+1) = gray_1(start_r:(start_r+2),start_c:(start_c+2));
generated_2(half_window+ceil(final_rows/2)-1:half_window+ceil(final_rows/2)+1,half_window+ceil(final_columns/2)-1:half_window+ceil(final_columns/2)+1) = gray_2(start_r:(start_r+2),start_c:(start_c+2));
generated_3(half_window+ceil(final_rows/2)-1:half_window+ceil(final_rows/2)+1,half_window+ceil(final_columns/2)-1:half_window+ceil(final_columns/2)+1) = gray_3(start_r:(start_r+2),start_c:(start_c+2));
filled(half_window+ceil(final_rows/2)-1:half_window+ceil(final_rows/2)+1,half_window+ceil(final_columns/2)-1:half_window+ceil(final_columns/2)+1) = ones(3,3);

kernel = ones(window_size,window_size);
kernel(half_window+1,half_window+1) = 0;

ind = -half_window:half_window;
[X, Y] = meshgrid(ind,ind);
gaussian = exp(-(X.^2 + Y.^2) / (2*sigma*sigma));
gaussian = gaussian(:);
gaussian = repmat(gaussian,[3,1]);
loop = 0;

while sum(sum(filled(half_window+1:final_rows+half_window,half_window+1:final_columns+half_window)<1))
    loop = loop+1;
    flag = 0;
        neighbours_of_unfilled = (filled(half_window+1:final_rows+half_window,half_window+1:final_columns+half_window) < 1).*conv2(filled(half_window+1:final_rows+half_window,half_window+1:final_columns+half_window),kernel,'same');
        neighbours_of_unfilled = neighbours_of_unfilled(:);
        [values, present] = sort(neighbours_of_unfilled,'descend');       
        for temp = 1:length(present)
            if neighbours_of_unfilled(present(temp)) < 1
                break;
            end
            pos = present(temp);
            [row,column] = ind2sub([final_rows,final_columns],pos);
            row = row + half_window;
            column = column + half_window;
            neighbourhood_1 = generated_1(row-half_window:row+half_window,column-half_window:column+half_window);
            neighbourhood_2 = generated_2(row-half_window:row+half_window,column-half_window:column+half_window);
            neighbourhood_3 = generated_3(row-half_window:row+half_window,column-half_window:column+half_window);
            neighbourhood_1 = neighbourhood_1(:);
            neighbourhood_2 = neighbourhood_2(:);
            neighbourhood_3 = neighbourhood_3(:);
            neighbourhood = [neighbourhood_1;neighbourhood_2;neighbourhood_3];
            neighbourhood_filled_1 = filled(row-half_window:row+half_window,column-half_window:column+half_window);
            neighbourhood_filled_1 = neighbourhood_filled_1(:);
            neighbourhood_filled = repmat(neighbourhood_filled_1,[3,1]);
            norm_factor = sum(neighbourhood_filled.*gaussian);
            distances = (sum((((gray_stacked - neighbourhood).*neighbourhood_filled).^2).*gaussian))/norm_factor;
            min_distance = min(distances);
            valid = find(distances<=((1+epsilon)*min_distance));
            random_pick = valid(randi(length(valid)));
            if distances(random_pick) < max_distance
                flag = 1;
                generated_1(row,column) = gray_1(random_pick);
                generated_2(row,column) = gray_2(random_pick);
                generated_3(row,column) = gray_3(random_pick);
                filled(row,column) = 1;
            end
        end
        
        output(:,:,1) = generated_1(half_window+1:final_rows+half_window,half_window+1:final_columns+half_window);
        output(:,:,2) = generated_2(half_window+1:final_rows+half_window,half_window+1:final_columns+half_window);
        output(:,:,3) = generated_3(half_window+1:final_rows+half_window,half_window+1:final_columns+half_window);
        imshow(output);
        
       if flag < 1
           max_distance = 1.1*max_distance;
       end
       
       [imind,cm] = rgb2ind(output,256);        
       if loop == 1
           imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
       else
           imwrite(imind,cm,filename,'gif','WriteMode','append');
       end
end

        
end


