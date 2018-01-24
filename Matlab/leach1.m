clc, clear all, close all

%membuat arsitektur jaringan
%luar area
wsn.area.x=100;
wsn.area.y=100;

%lokasi BS
wsn.bs.x=0.5*wsn.area.x;
wsn.bs.y=0.5*wsn.area.y;
figure(1),hold on;
plot(wsn.bs.x,wsn.bs.y,'o','MarkerFaceColor', 'r');


%inisialisasi energi
%energi awal
wsn.energi.init=0.5;
%energi transfer
wsn.energi.transfer=50*0.000000001;
%energi receive
wsn.energi.receive=50*0.000000001;
%energi aggregation
wsn.energi.aggregation=5*0.000000001;
%energi freespace
wsn.energi.freespace=10*0.000000000001;
%energi multipath
wsn.energi.multipath=0.0013*0.000000000001;

%membuat node
%jumlah node
wsn.jumlahNode=100;

%lokasi node
for i=1:wsn.jumlahNode
    %membuat koordinat x dari node
    wsn.node(i).x=rand*wsn.area.x;
    %membuat koordinat y dari node
    wsn.node(i).y=rand*wsn.area.y;
    wsn.node(i).G=0;
    %type non-CH
    wsn.node(i).type='N';
    %energi yang dimiliki node
    wsn.node(i).energi = wsn.energi.init;
    %penanda CH
    wsn.node(i).CH = -1;
    %node mati 0 -> hidup, 1 -> mati
    wsn.dead(i) =0;
end
%node hidup = jumlah node
wsn.nodeHidup= wsn.jumlahNode;
%node mati masih nol
wsn.nodeMati = 0;

for i=1:wsn.jumlahNode
    %menampilkan node ke grafik
    plot(wsn.node(i).x,wsn.node(i).y,'o');
    hold on;
end

%membuat round
%jumlah maksimal
wsn.jumlahRound=9999;
%panjang paket CH -> BS
wsn.panjangPaket=6400;
%panjang paket non-CH -> CH
wsn.panjangPaketMember=200;

%proses clustering
%jumlah cluster
wsn.jumlahCluster=5;
wsn.prob=1/wsn.jumlahCluster;

par =struct;
for i=1:wsn.jumlahRound
    %reset CH
    if(mod(i,wsn.jumlahCluster)==0)
        for j=1:wsn.jumlahNode
            wsn.node(j).G=0;
        end
    end
    
    %cek node mati
    nodeMati=find(wsn.dead);
    for j= nodeMati
        if wsn.node(j).energi <=0
            wsn.node(j).type='D';
            wsn.dead(j) =1;
        else
            wsn.node(j).type='N';
        end
    end
    
    %mencari CH
    clusterNode= struct();
    nodeMati=find(wsn.dead);
    jumlahCH=0;
    for j=nodeMati
        temp=rand;
        if(wsn.node(j).G <=0) && ...
                (temp <= prob(i,wsn.prob)) && ...
                (wsn.node(j).energi > 0)
            jumlahCH = jumlahCH+1;
            wsn.node(j).type='C';
            wsn.node(1,1).G = round(1/wsn.prob)-1;
            clusterNode.no(jumlahCH) = j;
            xLoc = wsn.node(j).x;
            yLoc = wsn.node(j).y;
            clusterNode.node(jumlahCH).x=xLoc;
            clusterNode.node(jumlahCH).y=yLoc;
            clusterNode.jarak(jumlahCH) = sqrt((xLoc-wsn.bs.x)^2+(yLoc-wsn.bs.y)^2);
        end
    end
    clusterNode.jumlahCH= jumlahCH;
    %CH
    d0=sqrt(wsn.energi.freespace/wsn.energi.multipath);
    if clusterNode.jumlahCH == 0
        break
    end
    n=length(clusterNode.no);
    for k=1:n
        chNo = clusterNode.no(k);
        jarak = clusterNode.jarak(k);
        energi = wsn.node(k).energi;
        if (jarak >=d0)
            wsn.node(k).energi = energi - ...
                ((wsn.energi.transfer+wsn.energi.aggregation)*wsn.panjangPaket+ ...
                wsn.energi.multipath*wsn.panjangPaket*(jarak^4));
        else
            wsn.node(k).energi = energi - ...
                ((wsn.energi.transfer+wsn.energi.aggregation)*wsn.panjangPaket+ ...
                wsn.energi.freespace*wsn.panjangPaket*(jarak^2));
        end
        
        wsn.node(k).energi = wsn.node(k).energi - ...
            wsn.panjangPaketMember * wsn.energi.receive * round(wsn.jumlahNode/clusterNode.jumlahCH);
    end
    
    %member
    nodeMati=find(wsn.dead);
    for j= nodeMati
        if strcmp(wsn.node(j).type,'N') && ...
                wsn.node(j).energi >0
            lokasiNode = [wsn.node(j).x,wsn.node(j).y];
            [jarakTerdekat, loc] = min(sqrt(sum((repmat(lokasiNode, n, 1) - clusterNode.loc)' .^ 2)));
            jarakCHTerdekat =  clusterNode.no(loc);
            if(jarakTerdekat > d0)
                wsn.node(j).energi = wsn.node(j).energi - ...
                    wsn.panjangPaketMember*wsn.energi.transfer + ...
                    wsn.energi.multipath*wsn.panjangPaket*(jarakTerdekat^4);
            else
                wsn.node(j).energi = wsn.node(j).energi - ...
                    wsn.panjangPaketMember*wsn.energi.transfer + ...
                    wsn.energi.freespace*wsn.panjangPaket*(jarakTerdekat^2);
            end
            
            if (jarakTerdekat >0 )
                wsn.node(j).energi = wsn.node(j).energi - ...
                    ((wsn.energi.transfer+wsn.energi.aggregation)*wsn.panjangPaket);
            end
        end
    end
    
    %jumlah paket
    if i==1
        par.paketKeBS(i)=wsn.jumlahCluster;
    else
        par.paketKeBS(i)=par.paketKeBS(i-1) + clusterNode.jumlahCH;
    end
    
    plot(1:i,par.paketKeBS,'Parent',subplot2,'LineWidth',2);
    %jika jumlah node mati sama dengan jumlah node keseluruhan maka akan
    %berhenti
    if wsn.dead==wsn.jumlahNode 
        break
    end
end