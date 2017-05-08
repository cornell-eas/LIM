function addstates(varargin)

bndry_file_list={'/Users/tra38/ClimX/states/arizona'
    '/Users/tra38/ClimX/states/oregon'
    '/Users/tra38/ClimX/states/california'
'/Users/tra38/ClimX/states/nevada'
'/Users/tra38/ClimX/states/idaho'
'/Users/tra38/ClimX/states/washington'
'/Users/tra38/ClimX/states/new_mexico'
'/Users/tra38/ClimX/states/colorado'
'/Users/tra38/ClimX/states/utah'
'/Users/tra38/ClimX/states/montana'
'/Users/tra38/ClimX/states/wyoming'
'/Users/tra38/ClimX/states/nebraska'
'/Users/tra38/ClimX/states/texas'
'/Users/tra38/ClimX/states/oklahoma'};

for i =1:length(bndry_file_list)
    [lon,lat]=m_plotbndry(bndry_file_list{i},'LineWidth',1,'Color','k');
    if length(varargin)==1;
        hold on
        m_plot(lon180_360(lon),lat,'linewidth',varargin{1},'color','k')
    end
end
% 
% m_plotbndry(,'LineWidth',1,'Color','k')
% m_plotbndry(,'LineWidth',1,'Color','k')
% m_plotbndry(,'LineWidth',1,'Color','k')
% m_plotbndry(,'LineWidth',1,'Color','k')
% m_plotbndry(,'LineWidth',1,'Color','k')
% m_plotbndry(,'LineWidth',1,'Color','k')
% m_plotbndry(,'LineWidth',1,'Color','k')
% m_plotbndry(,'LineWidth',1,'Color','k')
% m_plotbndry(,'LineWidth',1,'Color','k')
% m_plotbndry(,'LineWidth',1,'Color','k')
% m_plotbndry(,'LineWidth',1,'Color','k')
% m_plotbndry(,'LineWidth',1,'Color','k')
% m_plotbndry(,'LineWidth',1,'Color','k')