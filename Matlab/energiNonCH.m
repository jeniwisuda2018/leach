function [ hasilCluster ] = energiNonCH( hasilCluster, round )
    node = hasilCluster.node;
    jaringan  = hasilCluster.jaringan;
    cluster  = hasilCluster.clusterNode;
    if hasilCluster.jumlahCH == 0
        return
    end
    d0 = sqrt(jaringan.energi.freeSpace / ...
              jaringan.energi.multiPath);
    ETX = jaringan.energi.transfer;
    ERX = jaringan.energi.receiver;
    EDA = jaringan.energi.aggr;
    Emp = jaringan.energi.multiPath;
    Efs = jaringan.energi.freeSpace;
    panjangPaket = round.panjangPaket;
    panjangPaketMember = round.panjangPaketMember;
    
    locAlive = find(~node.dead); % find the nodes that are alive
    for i = locAlive % search in alive nodes
        %find Associated CH for each normal node
        if strcmp(node.node(i).type, 'N') &&  ...
            node.node(i).energi > 0
            
            locNode = [node.node(i).x, node.node(i).y];
            countCH = length(cluster.no); % Number of CHs
            % calculate distance to each CH and find smallest distance
            [minDis, loc] = min(sqrt(sum((repmat(locNode, countCH, 1) - cluster.loc)' .^ 2)));
            minDisCH =  cluster.no(loc);
            
            if (minDis > d0)
                node.node(i).energi = node.node(i).energi - ...
                    panjangPaketMember * ETX + Emp * panjangPaket * (minDis ^ 4);
            else
                node.node(i).energi = node.node(i).energi - ...
                    panjangPaketMember * ETX + Efs * panjangPaket * (minDis ^ 2);
            end
            %Energy dissipated
            if(minDis > 0)
                node.node(minDisCH).energi = node.node(minDisCH).energi - ...
                    ((ERX + EDA) * panjangPaket );
            end
        end % if
    end % for
    hasilCluster.node = node;
end

