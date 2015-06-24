function [ model ] = createCell( model )
% Create Centre Cell
N = model.config.NumCells;
R = model.sector_info.R;
xcoord = R*[-1; -0.5; 0.5; 1; 0.5; -0.5; -1];
ycoord = R*sqrt(3)*[0; -0.5; -0.5; 0; 0.5; 0.5; 0];
model.cell.coord = zeros(7,2*model.config.sector_size,N);

figure
hold on
colour_centre = [0    0.2800    1.0000];
colour_teir_1 = [0.5000    1.0000         0];
colour_teir_2 = [1.0000    0.1500         0];
theta = pi/3;

colourList = [colour_centre;repmat(colour_teir_1,6,1);repmat(colour_teir_2,12,1) ];
list = [.7 .9 .7; .6 .9 .6; .5 .9 .6];

sectorCount = 1;
for i = 1:N
    x0 = model.sector.position(:,1,i);
    y0 = model.sector.position(:,2,i);
    c1 = 1; c2 = 2;
    for ii = 1:model.config.sector_size
        model.cell.coord(:,c1:c2,i) = [xcoord+x0(ii) ycoord+y0(ii)];
        fill(model.cell.coord(:,c1,i),model.cell.coord(:,c2,i),colourList(i,:))
        sector_sector_D(1,:) = pdist2(model.sector.coord(sectorCount,:),model.sector.coord,'euclidean'); % euclidean distance
        reuseD_idx = round(sector_sector_D) == model.config.reuseD;
        text(model.sector.coord(sectorCount,1),model.sector.coord(sectorCount,2),num2str(sectorCount),'HorizontalAlignment','center',... 
            'BackgroundColor',list(ii,:))
        c1 = c1+2; c2 = c2+2;
%         text(model.sector.coord(reuseD_idx,1),model.sector.coord(reuseD_idx,2),num2str(sectorCount),'HorizontalAlignment','center',... 
%             'BackgroundColor',list(ii,:))
        c1 = c1+2; c2 = c2+2;
        sectorCount = sectorCount+1;
    end
    x = model.bs.position(i,1);
    y = model.bs.position(i,2);
    d = model.sector_info.r/2;
    tmp = [d*cos(theta) ...
    d*sin(theta)];
    plot([x x+d],[y y],'k','Linewidth',2)
    plot([x x-tmp(1,1)],[y y+tmp(1,2)],'k','Linewidth',2)
    plot([x x-tmp(1,1)],[y y-tmp(1,2)],'k','Linewidth',2)
    text(x,y,num2str(i),'HorizontalAlignment','center',... 
	'BackgroundColor',[.2 .9 .2])
    
end

end

   