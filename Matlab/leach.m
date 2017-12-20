clc, clear all, close all

%definisi jumlah node
jumlahNode = 100;

%definisi luas area
area.x=100;
area.y=100;

%definisi lokasi Base Station
bs.x = 0.5*area.x;
bs.y = 0.5*area.y;

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

%inisialisasi koordinat node
for i=1:jumlahNode
    %membuat koordinat x dari node
    wsn.node(i).x=rand*area.x;
    %membuat koordinat y dari node
    wsn.node(i).y=rand*area.y;
    %menampilkan node ke grafik
    plot(wsn.node(i).x,wsn.node(i).y,'o');
    hold on;
end

%inisialisasi node hidup dan node mati
wsn.nodeHidup = jumlahNode;
wsn.nodeMati=0;

%menampilkan base station
plot(bs.x,bs.y,'o','MarkerFaceColor', 'r');
%menampilkan label grafik
xlabel('meter');
ylabel('meter');

%inisialisasi jumlah round
jumlahRound=100;
for j=1:jumlahRound
    
end
