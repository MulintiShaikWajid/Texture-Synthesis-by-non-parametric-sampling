function detect_hole(initial_x, initial_y)
global original_padded
global filled

filled(initial_x, initial_y) = 0;
if (original_padded(initial_x-1, initial_y-1) == 0) & (filled(initial_x-1, initial_y-1) == 1)
    detect_hole(initial_x-1, initial_y-1);
end
if (original_padded(initial_x-1, initial_y) == 0) & (filled(initial_x-1, initial_y) == 1)
    detect_hole(initial_x-1, initial_y);
end
if (original_padded(initial_x-1, initial_y+1) == 0) & (filled(initial_x-1, initial_y+1) == 1)
    detect_hole(initial_x-1, initial_y+1);
end
if (original_padded(initial_x, initial_y-1) == 0) & (filled(initial_x, initial_y-1) == 1)
    detect_hole(initial_x, initial_y-1);
end
if (original_padded(initial_x, initial_y+1) == 0) & (filled(initial_x, initial_y+1) == 1)
    detect_hole(initial_x, initial_y+1);
end
if (original_padded(initial_x+1, initial_y-1) == 0) & (filled(initial_x+1, initial_y-1) == 1)
    detect_hole(initial_x+1, initial_y-1);
end
if (original_padded(initial_x+1, initial_y) == 0) & (filled(initial_x+1, initial_y) == 1)
    detect_hole(initial_x+1, initial_y);
end
if (original_padded(initial_x+1, initial_y+1) == 0) & (filled(initial_x+1, initial_y+1) == 1)
    detect_hole(initial_x+1, initial_y+1);
end

end