background = imread('background1.jpg');
backgroundG = sum(background, 3) / 3;
backgroundD = double(backgroundG) / 255;

foreground = imread('foreground1.jpg');
foregroundG = sum(foreground, 3) / 3;
foregroundD = double(foregroundG) / 255;

subtr = foregroundD ./ backgroundD;

figure(1)
colormap(gray)
imagesc(backgroundD)

figure(2)
colormap(gray)
imagesc(foregroundD)

figure(3)
colormap(gray)
imagesc(subtr)

edges = [0:255];

[r, c] = size(subtr);
imagevector = floor(reshape(subtr, 1, r * c) * 255);

theHist = histc(subtr, edges);

figure(4)
plot(theHist)