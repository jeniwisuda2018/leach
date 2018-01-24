function [ hasilCluster ] = energiCH( hasilCluster, round )
    jaringan = hasilCluster.jaringan;
    node = hasilCluster.node;
    cluster  = hasilCluster.clusterNode;
    
    d0 = sqrt(jaringan.energi.freeSpace / jaringan.energi.multiPath);
    if hasilCluster.jumlahCH == 0
        return
    end
    n = size(cluster.no); % Number of CHs
    ETX = jaringan.energi.transfer;
    ERX = jaringan.energi.receiver;
    EDA = jaringan.energi.aggr;
    Emp = jaringan.energi.multiPath;
    Efs = jaringan.energi.freeSpace;
    panjangPaket = round.panjangPaket;
    panjangPaketMember = round.panjangPaketMember;
    for i = 1:n
        chNo = cluster.no(i);
        jarak = cluster.jarak(i);
        energi = node.node(chNo).energi;
        % energy for aggregation the data + energy for transferring to BS
        if(jarak >= d0)
             node.node(chNo).energi = energi - ...
                 ((ETX+EDA) * panjangPaket + Emp * panjangPaket * (jarak ^ 4));
        else
             node.node(chNo).energi = energi - ...
                 ((ETX+EDA) * panjangPaket + Efs * panjangPaket * (jarak ^ 2));
        end
        %node.node(chNo).energi = node.node(chNo).energi - panjangPaketMember * ERX * round(node.jumlahNode / hasilCluster.jumlahCluster);
        node.node(chNo).energi
    end
    
    hasilCluster.node = node;
end

