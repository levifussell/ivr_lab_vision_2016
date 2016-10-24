% loads a given image
function newImage = myjpgload(name, show, hist)
    newImage = (imread(name, 'jpg'));
    if show > 0
        figure(show)
        colormap(gray)
        imagesc(newImage)
    end

    if hist > 0
        % theHist = zeros(256, 1);
        % [H, W] = size(newImage);

        % for r = 1:H
        %     for c = 1:W
        %         value = round(newImage(r, c));
        %         if value < 0
        %             value = 0;
        %         elseif value > 255
        %             value = 255;
        %         end

        %         theHist(value + 1) = theHist(value + 1) + 1;
        %     end
        % end

        edges = zeros(256, 1);
        for i = 1:256
            edges(i) = i - 1;
        end
        [R, C] = size(newImage);
        imagevec = reshape(newImage, 1, R*C);
        theHist = transpose(histc(imagevec, edges));

        figure(4)
        plot(theHist)
        axis([0, 255, 0, 1.1*max(theHist)])
    end
end