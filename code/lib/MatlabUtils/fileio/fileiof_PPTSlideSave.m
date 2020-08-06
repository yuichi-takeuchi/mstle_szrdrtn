function [ flag ] = fileiof_PPTSlideSave( filenamelist, fullpath ,destName )
%
%   [ flag ] = fileiof_PPTSlideSave( filenamelist, destName )
%    filenamelist: string vector of srcfiles (eg. 'source.png')
%    destName: Name string of destination file (eg. 'destination.ppt')
%
% (c) Yuichi Takeuchi 2017

flag = 0;
h = actxserver('PowerPoint.Application') ;
h.Visible = 1; 
% h.Help 
h.Presentation.invoke;
Presentation = h.Presentation.Add;
blankSlide = Presentation.SlideMaster.CustomLayouts.Item(7);

for i = length(filenamelist):-1:1
    slide = Presentation.Slides.AddSlide(1,blankSlide);
%     slidefile = filenamelist;
    slidefile = filenamelist{i};
% 
%     Image1 = slide.Shapes.AddPicture([fullpath '\test1.png'],'msoFalse','msoTrue',0, 0,960, 540);
    Image{i} = slide.Shapes.AddPicture([fullpath '\' slidefile], 'msoFalse', 'msoTrue', 120, 0, 718, 540);  
end
Presentation.SaveAs([fullpath '\' destName])
% h.Quit;
h.delete;

flag = 1;

