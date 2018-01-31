clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Luas Area (meter)
xm=100;
ym=100;
%Koordinat Base Station/Sink 
sink.x=0.5*xm;
sink.y=0.5*ym;

%Jumlah Node
n=100;
kbytes=100;
bbytes=25;

%Pemilihan Optimal Probabilitas sebuah node menjadi cluster head
p=0.1; %untuk mendapat nilai optimum, beberapa refrensi bilang 0.05

%ENERGI (Joule)
%Energi Awal 
Eo=0.25;
%Eelec=Etx;Erx (Tx=Transmit;Rx=Receiver)
ETX=33*0.0000001;
ERX=7*0.0000001;
%Transmit Amplifier types (fs=Free Space;mp=Multipath)
Efs=1.5*0.001*0.000000000001;
Emp=2.5*0.000001*0.000000000001;
%Data Aggregation Energy
EDA=5*0.000000001;

%maximum number of rounds
rmax=300
%%%%%%%%%%%%%%%%%%%%%%%%% END OF PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%

%Computation of do
do=sqrt(Efs/Emp);
%Randon Sensor Node
figure(1);
for i=1:1:n
    S(i).xd=rand(1,1)*xm;
    XR(i)=S(i).xd;
    S(i).yd=rand(1,1)*ym;
    YR(i)=S(i).yd;
    S(i).G=0;  %Inisialisasi bahwa belum ada CH
    S(i).type='N';
		S(i).E=Eo;
		plot(S(i).xd,S(i).yd,'o'); %menampilkan normal nodes dengan simbol 'o'
        hold on;
end
S(n+1).xd=sink.x;
S(n+1).yd=sink.y;
plot(S(n+1).xd,S(n+1).yd,'x'); %menampilkan BS/Sink dengan simbol 'x'

%Iterasi Pertama
figure(1);

%Menghitung CH
countCHs=0;
%Menghitung CHs per round
rcountCHs=0;
cluster=0;

countCHs;

Dtotal=zeros(1,rmax); 
packetsent=zeros(1,rmax); 
packetloss=zeros(1,rmax); 
data=zeros(1,rmax); 
loss=zeros(1,rmax); 
Etotal=zeros(1,rmax); 
Energy=zeros(rmax+1,n); 
Energy(1,:)=Eo;

for r=1:1:rmax
	r
	if (mod(r, round(1/p))==0)
		for i=1:1:n
		S(i).G=0;
		end
	end
	hold off;
	
	%Jumlah node yang mati
	dead=0;
	figure(1);
	for i=1:1:n
		%memeriksa jika ada node yang mati 
		if	(S(i).E<=0) 
			plot(S(i).xd,S(i).yd, 'red .');
			dead=dead+1; 
			S(i).type= 'D' ; 
			ronde(r).S(i).type= 'D' ;
			hold on ; 
		end 
		if	S(i).E>0 
			S(i).type= 'N' ; 
			ronde(r).S(i).type= 'N';
			plot(S(i).xd,S(i).yd, 'o' ); 
			hold on ; 
		end 
	end 
	plot(S(n+1).xd,S(n+1).yd, 'x' );
	
	TOTAL(r).DEAD=dead; 
	
	countCHs=0; 
	cluster=0; 
	for i=1:1:n 
		if (S(i).E>0) 
			temp_rand=rand; 
			if ( (S(i).G)<=0) 
			%Pemilihan CH
				if (temp_rand<= (p/(1-p*mod(r,round(1/p))))) 
				countCHs=countCHs+1; 
				
				S(i).type= 'C' ;
				ronde(r).S(i).type= 'C' ;
				S(i).G=round(1/p)-1; 
				ronde(r).S(i).G=round(1/p)-1; 
				cluster=cluster+1; 
				C(cluster).xd=S(i).xd; 
				ronde(r).C(cluster).xd=S(i).xd; 
				C(cluster).yd=S(i).yd; 
				ronde(r).C(cluster).yd=S(i).yd; 
				plot(S(i).xd,S(i).yd, 'k*' ); 
				
				distance=sqrt( (S(i).xd-(S(n+1).xd) )^2 + (S(i).yd-(S(n+1).yd) )^2 ); 
				C(cluster).distance=distance; 
				ronde(r).C(cluster).distance=distance; 
				C(cluster).id=i; 
				ronde(r).C(cluster).id=i; 
				C(cluster).Einit=S(i).E; 
				ronde(r).C(cluster).Einit=S(i).E; 
				
				for j=1:n 
					if (j~=i) 
						dist = sqrt ( (S(i).xd-(S(j).xd) )^2 + (S(i).yd-(S(j).yd) )^2 ); 
						if (dist>do) 
							ETBroad=ETX*bbytes + Emp*bbytes*( dist* dist * dist * dist); 
						end 
						if (dist<=do) 
							ETBroad=ETX*bbytes + Efs*bbytes*( dist * dist); 
						end 
						S(i).E = S(i).E -ETBroad; 
						if (S(i).E<=0) 
							ronde(r).S(i).type= 'D' ; 
						end 
						
						ERBroad =( ERX *bbytes );
						S(j).E = S(j).E -ERBroad; 
						if (S(j).E<=0) 
							ronde(r).S(j).type= 'D' ; 
						end 
					end 
				end 
			end 
		end 
	end 
		cluster; 
end 
	
TOTAL(r).CLUSTER=cluster; 

%Pemilihan CH untuk node normal
for i=1:1:n 
	if ( S(i).type== 'N' && S(i).E>0 ) 
		if (cluster>=1) 
			min_dis=9999; 
			min_dis_cluster=1; 
			for c=1:1:cluster 
				temp=min(min_dis,sqrt( (S(i).xd-C(c).xd)^2 + (S(i).yd- C(c).yd)^2 ) );
					
				if ( temp<min_dis ) 
					min_dis=temp; 
					min_dis_cluster=c; 
				end 
			end 
			%Energi yang digunakan CH
			min_dis;
			min_dis_cluster=c; 
				if (min_dis>do) 
					S(i).E=S(i).E- ( ETX*(kbytes) + Emp*kbytes*( min_dis * min_dis * min_dis * min_dis)); 
					ronde(r).S(i).E=S(i).E- ( ETX*kbytes + Emp*kbytes*( min_dis * min_dis * min_dis * min_dis)); 
				end 
				if (min_dis<=do) S(i).E=S(i).E- ( ETX*(kbytes) + Efs*kbytes*( min_dis * min_dis)); 
					ronde(r).S(i).E=S(i).E- ( ETX*kbytes + Efs*kbytes*( min_dis * min_dis)); 
				end 
			
				if (S(i).E<=0)
					S(i).type= 'D' ;
				end 
			
			%Energi yang digunakan
			if (min_dis>0) 
				S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E- ( (ERX + EDA)*kbytes ); 
				ronde(r).S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E- ( (ERX + EDA)*kbytes );
			end 
		
			if (S(C(min_dis_cluster).id).E<=0) 
			
				plot(S(C(min_dis_cluster).id).xd,S(C(min_dis_cluster). id).yd, 'red .' );
				dead=dead+1; 
				S(C(min_dis_cluster).id).type= 'D' ; 
				ronde(r).S(C(min_dis_cluster).id).type= 'D' ; 
				hold on ; 
			end 
			
			%Perhitungan Energi yang digunakan CH
			if (C(min_dis_cluster).distance>do) 
				ch2bs=( (ETX+EDA)*kbytes + Emp*kbytes*( C(min_dis_cluster).distance )^4); 
			end 
			if (C(min_dis_cluster).distance<=do) 
				ch2bs=( (ETX+EDA)*kbytes + Efs*kbytes*( C(min_dis_cluster).distance )^2); 
			end 
		
			ch2bs; 
			if 	ch2bs>S(C(min_dis_cluster).id).E 
				packetloss(1,r)=packetloss(1,r)+1; 
				loss(1,r)=loss(1,r)+100; 
			end 
			
			if 	ch2bs<=S(C(min_dis_cluster).id).E 
				packetsent(1,r)=packetsent(1,r)+1; 
				data(1,r)=data(1,r)+100; 
            end

			S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E - ch2bs;
			ronde(r).S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E - ch2bs; 
			S(i).min_dis=min_dis; 
			ronde(r).S(i).min_dis=min_dis; 
			S(i).min_dis_cluster=min_dis_cluster; 
			ronde(r).S(i).min_dis_cluster=min_dis_cluster; 
						
			if (S(C(min_dis_cluster).id).E<=0) 
				S(C(min_dis_cluster).id).type= 'D' ;
				ronde(r).S(C(min_dis_cluster).id).type= 'D' ; 
			end 
		else 
			min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd- S(n+1).yd)^2 ); 
						
			%Energi yang digunakan dari node ke BS/Sink
			if (min_dis>do) 
				n2bs=( (ETX+EDA)*kbytes + Emp*kbytes*( min_dis )^4); 
			end 
			if (min_dis<=do) 
				n2bs=( (ETX+EDA)*kbytes + Efs*kbytes*( min_dis )^2); 
			end 
		
			n2bs; 
			if n2bs>S(i).E 
				packetloss(1,r)=packetloss(1,r)+1; 
				loss(1,r)=loss(1,r)+100;
			end 

			if n2bs<=S(i).E 
				packetsent(1,r)=packetsent(1,r)+1; 
				data(1,r)=data(1,r)+100; 
			end 
						
			S(i).E = S(i).E - n2bs; 
			ronde(r).S(i).E = S(i).E - n2bs; 
			S(i).min_dis=min_dis; 
			ronde(r).S(i).min_dis=min_dis; 
			S(i).min_dis_cluster=n+1; 
			ronde(r).S(i).min_dis_cluster=n+1; 
						
			if (S(i).E<=0) 
				S(i).type= 'D' ; 
				ronde(r).S(i).type= 'D' ; 
			end 
		end 
	else 
		if ( S(i).type== 'C' && S(i).E>0 ) 
			min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd- S(n+1).yd)^2 ); 
						
			%Energi yang digunakan dari node ke BS/Sink
			if (min_dis>do) 
				n2bs=( (ETX)*kbytes + Emp*kbytes*( min_dis )^4); 
			end 
		
			if (min_dis<=do) 
				n2bs=( (ETX)*kbytes + Efs*kbytes*( min_dis )^2); 
			end 
			
			n2bs; 
			if 	n2bs>S(i).E 
				packetloss(1,r)=packetloss(1,r)+1; 
				loss(1,r)=loss(1,r)+100; 
			end 
						
			if	n2bs<=S(i).E 
				packetsent(1,r)=packetsent(1,r)+1; 
				data(1,r)=data(1,r)+100; 
			end
				
			S(i).E = S(i).E - n2bs; 
			ronde(r).S(i).E = S(i).E - n2bs; 
			S(i).min_dis=min_dis; 
			ronde(r).S(i).min_dis=min_dis; 
			S(i).min_dis_cluster=n+1; 
			ronde(r).S(i).min_dis_cluster=n+1; 
						
			if 	(S(i).E<=0) 
				S(i).type= 'D' ; 
				ronde(r).S(i).type= 'D' ; 
			end 
		end 
	end 
	if 	(S(i).E>=0) 
		Energy(r+1,i)=S(i).E; 
		Etotal(r)=Etotal(r)+S(i).E; 
	end 
end

hold on ; 
countCHs; 
TOTAL(r).CH=countCHs; 
Dtotal(r)=TOTAL(r).DEAD; 
rcountCHs=rcountCHs+countCHs; 

hold off ; 
figure(2); 
subplot1 = subplot(1,3,3, 'Parent' ,figure(2)); 
box(subplot1, 'on' ); 
hold(subplot1, 'all' ); 
r=(1:r); 
plot(r, Etotal(r), 'Parent' ,subplot1, 'LineWidth' ,2, 'Color' ,[0 1 0]); 
xlabel( 'Round' , 'FontWeight' , 'bold' , 'FontSize' ,11, 'FontName' , 'Cambr ia' ); 
ylabel( 'sum of energy' , 'FontWeight' , 'bold' , 'FontSize' ,11, ...
'FontName' , 'Cambria' );
title( 'Sum of energy of nodes vs. round' , 'FontWeight' , 'bold' , 'FontSize' ,12, ...
'FontName' , 'Cambria' );

subplot2 = subplot(1,3,1, 'Parent' ,figure(2));
box(subplot2, 'on' ); 
hold(subplot2, 'all' ); 
plot(r,data(1,r), 'Parent' ,subplot2, 'LineWidth' ,2); 
xlabel( 'Round' , 'FontWeight' , 'bold' , 'FontSize' ,11, 'FontName' , 'Cambr ia' ); 
ylabel( 'Sum of packets sent to BS nodes' , 'FontWeight' , 'bold' , 'FontSize' ,11, ...
'FontName' , 'Cambria' );
title( 'Number of packet sent to BS vs. round' , 'FontWeight' , 'bold' , ...  
'FontSize' ,12, ... 
'FontName' , 'Cambria' );

subplot3 = subplot(1,3,2, 'Parent' ,figure(2)); 
box(subplot3, 'on' ); 
hold(subplot3, 'all' ); 
plot(r,Dtotal(r), 'Parent' ,subplot3, 'LineWidth' ,2, 'Color' ,[1 0 0]); 
xlabel( 'Round' , 'FontWeight' , 'bold' , 'FontSize' ,11, 'FontName' , 'Cambr ia' ); 
ylabel( 'Sum of dead nodes' , 'FontWeight' , 'bold' , 'FontSize' ,11, ...
'FontName' , 'Cambria' ); 
title( 'Number of dead node vs. round' , 'FontWeight' , 'bold' , 'FontSize' ,12, ...
'FontName' , 'Cambria' );
end