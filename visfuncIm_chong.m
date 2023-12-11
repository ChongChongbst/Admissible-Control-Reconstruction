function [h,c] = visfuncIm_chong(g, data, color, extraArgs)
% h = visFuncIm(g, data, color, alpha)
% Code for quickly visualizing the value function
%
% Imputs: g          - grid structure
%         data       - value function corresponding to grid g
%         color      - (defaults to blue)
%         sliceDim   - for 3D ValueFunc, choose the dimension of the slices (defaults
%                      to last dimension)
%         applyLight - Whether to apply camlight (defaults to true)
%
% Output: h - figure handle
%
% Adapted from visfuncIm in helperOC
%
% Chong He, 2022-10-20

%% Default parameters and input check
if isempty(g)
    N = size(data)';
    g = createGrid(ones(numDims(data), 1), N, N);
end

if g.dim ~= numDims(data) && g.dim+1 ~= numDims(data)
    error('Grid dimension is inconsistent with data dimension!')
end

%% Defaults
if nargin < 3
    color = 'b';
end

if nargin < 4
    extraArgs = [];
end

deleteLastPlot = true;
if isfield(extraArgs, 'deleteLastPlot')
    deleteLastPlot = extraArgs.deleteLastPlot;
end

save_png = false;
if isfield(extraArgs, 'fig_filename')
    save_png = true;
    fig_filename = extraArgs.fig_filename;
end

contour_color = 'g';
if isfield(extraArgs, 'contour_color')
    contour_color = extraArgs.contour_color;
end

alpha = 0.1;
if isfield(extraArgs, 'alpha')
    alpha = extraArgs.alpha;
end

level = [0 0];
if isfield(extraArgs, 'level')
    level = extraArgs.level;
end

%% makeVideo
if isfield(extraArgs, 'makeVideo') && extraArgs.makeVideo
    if ~isfield(extraArgs, 'videoFilename')
        extraArgs.videoFilename = ...
            [datestr(now,'YYYYMMDD_hhmmss') '.mp4'];
    end
        
    vout = VideoWriter(extraArgs.videoFilename,'MPEG-4');
    vout.Quality = 100;
    if isfield(extraArgs, 'frameRate')
        vout.FrameRate = extraArgs.frameRate;
    else
        vout.FrameRate = 30;
    end
        
    try
        vout.open;
    catch
        error('cannot open file for writing')
    end
end

%% plot value function along the time 
if g.dim == numDims(data)
    % Visualize a single value function
    [h,c] = visFuncIm_single(g, data, color, alpha, level, contour_color);
    
    if save_png
        export_fig(fig_filename, '-png', '-m2');
    end

else
    dataSize = size(data);
    numFuncs = dataSize(end);

    colons = repmat({':'}, 1, g.dim);
    % Draw the initial zero level
    [M,c] = contour3(g.xs{1},g.xs{2},data(colons{:}, 1),level, contour_color);

    hold on
    for i = 1:numFuncs
        if deleteLastPlot
            if i > 1
                delete(h);
                delete(c);
            end            
            [h, c] = visFuncIm_single(g, data(colons{:}, i), color, alpha, level, contour_color);
        else
            if i == 1
                h = cell(numFuncs, 1);
                hold on
            end

            h{i} = visFuncIm_single(g, data(colons{:}, i), color, alpha, level, contour_color);
        end

        pause(0.1)
        if save_png
            export_fig(sprintf('%s_%d', fig_filename, i), '-png', '-m2');
        end
    end
    if isfield(extraArgs, 'makeVideo') && extraArgs.makeVideo
        vout.close
    end

end




%% Visualize a single value function
    function [h, contour] = visFuncIm_single(gPlot, dataPlot, color, alpha, level, contour_color)
% h = visFuncIm_single(g, data, color, extraArgs)
%       Displays value function depending on dimension of grid and data


if gPlot.dim<2
    h = plot(gPlot.xs{1}, squeeze(dataPlot),...
        'LineWidth',2);
    h.Color = color;
elseif gPlot.dim==2
    h = surf(gPlot.xs{1}, gPlot.xs{2}, dataPlot);
    hold on
    [M,contour] = contour3(gPlot.xs{1},gPlot.xs{2},dataPlot,level, contour_color);
    contour.LineWidth = 3;
    h.EdgeColor = 'none';
    h.FaceColor = color;
    h.FaceAlpha = alpha;
    h.FaceLighting = 'phong';
    % label Setting one
%     xlabel('-5 < x < 5') 
%     ylabel('-5 < y < 5')
%     zlabel('Value')
%     set(gca,'xticklabels',[])7u6y
%     set(gca,'yticklabels',[])
    hold on

else
    error('Can not plot in more than 3D!')
end

end
end






















