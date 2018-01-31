clc, clear all, close all

%menentukan jumlahNode yang digunakan
jumlahNode = 100;

%menentukan luas area jaringan/penempatan node
area.panjang=100;
area.lebar=100;

%menentukan lokasi base station (BS)
bs.x=0.5*area.panjang;
bs.y=0.5*area.lebar;

%membuat arsitektur jaringan
arsitekturJaringan = jaringan(area,bs);
%menentukan lokasi node dan atributnya
arsitekturNode = node(arsitekturJaringan, jumlahNode);
%round
round.jumlahRound=9999;
round.panjangPaket=6400;
round.panjangPaketMember=200;

for i=1:length(arsitekturNode.node)
    plot(arsitekturNode.node(i).x,arsitekturNode.node(i).y,'o');
    hold on;
end
plot(bs.x,bs.y,'o','MarkerFaceColor', 'r');

for i=1:round.jumlahRound
    hasilCluster = cluster(arsitekturJaringan, arsitekturNode, i, 4);
    hasilCluster = energiCH(hasilCluster, round);
    hasilCluster = energiNonCH(hasilCluster, round);   
    
end