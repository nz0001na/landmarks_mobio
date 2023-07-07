
clear all;
fid = fopen('img_output_68.txt','rt');
for i = 1:1
    filename = fgetl(fid);
    fpts = fscanf(fid,'%f',136)+1;
    fgetl(fid);
    fpts = reshape(fpts,[2 68]);
    fpts = fpts';
    
    img = imread(filename);
    imshow(img);
    hold on;
    plot(fpts(:,1),fpts(:,2),'o','MarkerEdgeColor', 'k', 'MarkerFaceColor','green');
    saveas(img,filename)
    hold off;
    pause;
end

