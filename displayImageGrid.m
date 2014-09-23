function f = displayImageGrid(results, cut)

% determine required rows of plots
cols = 2;
rows = ceil(length(cut)/cols);

% increase figure width for additional axes
fpos = get(gcf, 'position');
scrnsz = get(0, 'screensize');
fwidth = min([fpos(3)*cols, scrnsz(3)-20]);
fheight = fwidth/cols*.75; % maintain aspect ratio
set(gcf, 'position', [10 fpos(2) fwidth fheight])

% setup all axes
buf = .15/cols; % buffer between axes & between left edge of figure and axes
awidth = (1-buf*cols-.08/cols)/cols; % width of all axes
aidx = 1;
rowidx = 0;
while aidx <= length(cut)
    for i = 0:cols-1
        if aidx+i <= length(cut)
            start = buf + buf*i + awidth*i;
            apos{aidx+i} = [start 1-rowidx-.92 awidth .85];
            a{aidx+i} = axes('position', apos{aidx+i});
        end
    end
    rowidx = rowidx + 1; % increment row
    aidx = aidx + cols;  % increment index of axes
end

% make plots
for i = 1:length(cut)
    axes(a{i}), imshow(results{i},[]),title(strcat('Cut: ', num2str(cut(i))))
end

% determine the position of the scrollbar & its limits
swidth = max([.03/cols, 16/scrnsz(3)]);
ypos = [1-swidth 0 swidth 1];
ymax = 0;
ymin = -1*(rows-1);

% build the callback that will be executed on scrolling
clbk = '';
for i = 1:length(a)
    line = ['set(',num2str(a{i},'%.13f'),',''position'',[', ...
            num2str(apos{i}(1)),' ',num2str(apos{i}(2)),'-get(gcbo,''value'') ', num2str(apos{i}(3)), ...
            ' ', num2str(apos{i}(4)),'])'];
    if i ~= length(a)
        line = [line,','];
    end
    clbk = [clbk,line];
end

% create the slider
uicontrol('style','slider', ...
    'units','normalized','position',ypos, ...
    'callback',clbk,'min',ymin,'max',ymax,'value',0);

end