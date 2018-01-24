function [ cluster ] = cluster( jaringan, node, r, jumlahCluster )

    if ~exist('jaringan','var')
        jaringan = jaringan();
    end
    cluster.jaringan = jaringan;
    
    if ~exist('node','var')
        node = node();
    end
    cluster.node=node;
    
    if ~exist('jumlahCluster','var')
        jumlahCluster = 4;
    end
    cluster.jumlahCluster=jumlahCluster;
    
    cluster.prob = 1/jumlahCluster;
    
    %reset data
    if(mod(r, cluster.jumlahCluster))
        for i=1:node.jumlahNode
            node.node(i).G=0;
        end
    end
    
    cekNodeHidup = find(~node.nodeMati);
    for i = cekNodeHidup
        if node.node(i).energi <=0
            node.node(i).type = 'D';
            node.nodeMati = 1;
        else
            node.node(i).type = 'N';
        end
    end
    node.jumlahNodeMati = sum(node.nodeMati);
    
    clusterNode     = struct();
    cekNodeHidup = find(~node.nodeMati);    
    jumlahCH = 0;
    for i= cekNodeHidup
        temp = rand;
        if (node.node(i).G <=0) && (temp <= prob(r,cluster.prob)) && (node.node(i).energi > 0)
            jumlahCH = jumlahCH + 1;
            
            node.node(i).type = 'C';
            node.node(i).G = round(1/cluster.prob)-1;
            clusterNode.no(jumlahCH) = i;
            xLoc = node.node(i).x;
            yLoc = node.node(i).y;
            clusterNode.loc(jumlahCH,1).x=xLoc;
            clusterNode.loc(jumlahCH,2).y=yLoc;
            %jarak CH ke BS
            clusterNode.jarak(jumlahCH) = sqrt((xLoc - jaringan.lokasiBS.x)^2+(yLoc - jaringan.lokasiBS.y)^2);
            
        end
    end
    cluster.jumlahCH = jumlahCH;
    cluster.clusterNode=clusterNode;
end

