close all
clear
clc

% add MatConNet toolbox
run ./matconvnet-1.0-beta25/matlab/vl_setupnn.m;

% set gpuOn to your GPU index, set the value to 0 for CPU mode
gpuOn = 0;

% load a pre-trained CNN model
load('./model/cnn6_v1_aflw.mat');
net = dagnn.DagNN.loadobj(net);
if gpuOn
    gpuDevice(gpuOn);
    net.move('gpu');
end

% imglist = dir('./imgs/*.jpg');
% imglist = dir('F:/4_Facial landmark detection/1_DataImages/2 images/1 images_in_pairs/*.jpg')
imglist = dir('F:/4_Facial landmark detection/1_DataImages/5 detection_cropped_resize_MTCNN/3_resized/0_final_256_256/*.jpg')



inImgSize = net.meta.inputSize(1);

% apply the model to cropped face images for facial landmark localisation
for i = 1:length(imglist)
%     img = imread(['./imgs/' imglist(i).name]);
    img = imread(['F:/4_Facial landmark detection/1_DataImages/5 detection_cropped_resize_MTCNN/3_resized/0_final_256_256/' imglist(i).name]);
    
    tmpImg = imresize(img, [inImgSize, inImgSize]);
    tmpImg = im2single(tmpImg);
    if gpuOn
        tmpImg = gpuArray(tmpImg);
    end
    
    net.eval({'input', tmpImg});
    if gpuOn
        lmks = squeeze(gather(net.vars(end).value)) / inImgSize * size(img,1);
    else
        lmks = squeeze(net.vars(end).value) / inImgSize * size(img,1);
    end
    
    csvwrite(['./mobio_result/' imglist(i).name(1:end-3) 'csv'],lmks); 
%     csvwrite([src 'marked_cmck.csv'], marklist);
    
    imshow(img);
    hold on;
    a = plot(lmks(1:end/2), lmks(end/2+1:end), 'ko', 'MarkerFaceColor', 'yellow');
%     set(gca,'position',[0 0 1 1],'units','normalized') to 
%     set(gca,'Units','pixels'); %changes the Units property of axes to pixels
%     set(gca,'Position',[0 0 614 614]);
    %The first two elements correspond to the left and bottom define the distance from the lower-left corner of the container to the lower-left corner of the axes, the next two elements are the width and the height which can be updated to reflect the Image dimensions.
%     set(a,'units','pix','pos',[0,0,614,614])
%     imwrite(img, ['./img_result/' imglist(i).name(1:end-3) 'png']);
    saveas(a, ['./mobio_img/' imglist(i).name(1:end-3) 'png']);
%     title('Press any key to the next image!');
    hold off;
%     pause();
end