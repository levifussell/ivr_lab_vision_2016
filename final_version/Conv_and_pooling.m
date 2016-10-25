% unix('mplayer tv:// -tv driver=v4l2:width=140:height=140:device=/dev/video1 -frames 1 -vo jpeg');

I = imread('assign1_1.jpg');

Id = double(I) / 255;
Id_norm = Id ./ repmat(sum(Id, 3), [1, 1, 3]);
Ig = sum(I, 3) / 3;

figure(1)
colormap(gray)
imagesc(Ig)

Ig_smooth = conv2([4 0 0; 0 0 0; 0 0 -4], Ig);

figure(2)
colormap(gray)
imagesc(Ig_smooth)

Ig_pool_2 = max_pooling(Ig_smooth, 4);

figure(3)
colormap(gray)
imagesc(Ig_pool_2)

Ig_smooth_2 = conv2([0 0 4; 0 0 0; -4 0 0], Ig_pool_2);


figure(4)
colormap(gray)
imagesc(Ig_smooth_2)

Ig_pool_3 = max_pooling(Ig_smooth_2, 2);


figure(5)
colormap(gray)
imagesc(Ig_pool_3)


Ig_smooth_3 = conv2([0 -2 0; -2 0 2; 0 2 0], Ig_pool_3);

figure(6)
colormap(gray)
imagesc(Ig_smooth_3)

Ig_pool_4 = max_pooling(Ig_smooth_3, 2);


figure(7)
colormap(gray)
imagesc(Ig_pool_4)

x_v = [1:size(Ig_pool_4, 2)];
y_v = [1:size(Ig_pool_4, 1)];
[yy, xx] = meshgrid(x_v, y_v);
figure(8)
mesh(xx, yy, Ig_pool_4)

filt_g = gausswin(5, 2);
Ig_smooth_5 = conv2(Ig_pool_4, filt_g);
x_v = [1:size(Ig_smooth_5, 2)];
y_v = [1:size(Ig_smooth_5, 1)];
[yy, xx] = meshgrid(x_v, y_v);
figure(9)
mesh(xx, yy, Ig_smooth_5)

