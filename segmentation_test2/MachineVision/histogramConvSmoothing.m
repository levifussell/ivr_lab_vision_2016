imageColour = imread('00000002.jpg');
% imageGrey = sum(imageColour, 3) / 3;

imageColour = double(imageColour) / 255;

imageGrey = sum(imageColour, 3) / 3;

% draw image as a grey scale
figure(1)
colormap(gray)
imagesc(imageGrey)

% convM = [1 4 7 4 1; 4 16 26 16 4; 7 26 41 26 7; 4 16 26 16 4; 1 4 7 4 1];
% convM = [2 2 2; 0 0 0; -1 -1 -1];
convL = [-1 -1 -1; -1 8 -1; -1 -1 -1];
convR = transpose(convL);
% for i=2:5

imageGrey = conv2(imageGrey, convL);

figure(2)
colormap(gray)
imagesc(imageGrey)

imageGrey = conv2(conv2(imageGrey, convL), convR);

figure(3)
colormap(gray)
imagesc(imageGrey)
    % end

% draw histogram of image
% edges = [0:255];
%     % compress image into a single vector array
% [iRows, iColumns] = size(imageGrey);
% imagevector = reshape(imageGrey, 1, iRows * iColumns);
% imageHist = histc(imagevector, edges);

% figure(2)
% plot(imageHist)


% sizeparam = 4;
% filterlen = 50;
% thefilter = gausswin(filterlen, sizeparam);
% thefilter = thefilter / sum(thefilter);

% tmp2 = conv(thefilter, thehist);

% offset = floor((filterlen + 1) / 2);
% tmp1 = tmp2(offset:255 + offset - 1);

% figure(3)
% plot(tmp2)

% convert back to original image


