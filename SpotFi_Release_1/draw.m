function draw(clusters,num)
%      plot(1:90,[a(1,:),a(2,:),a(3,:)],'r--');
%      hold on;
%      plot(1:90,[b(1,:),b(2,:),b(3,:)],'b-');
%      legend('消除STO后','消除STO前');
%      xlabel('子载波编号');
%      ylabel('CSI相位值');
% for i=1:361
%     plot(0:100,Pmusic(i,:));
%     xlabel('ToF');
%     ylabel('Pmusic');
% end
    color = 0;
    figure(num);
    for i=1:size(clusters,1)
        length = ones(size(clusters{i,1},1),1);
        p = color*length;
        if size(clusters{i,1},1) == 0
            continue
        end
        scatter(clusters{i,1}(:,1),clusters{i,1}(:,2),10,p,'filled');
        hold on;
        color = color + 5;
    end
    xlabel('AoA');
    ylabel('ToF');
end