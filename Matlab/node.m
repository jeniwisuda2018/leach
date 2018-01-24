function [ arsitekturNode ] = node( arsitekturJaringan, jumlahNode )
    % arsitekturJaringan
    % jumlahNode
    
    if ~exist('arsitekturJaringan','var')
        arsitekturJaringan = jaringan();
    end
    
    if ~exist('jumlahNode','var')
        jumlahNode = 100;
    end
    
    for i=1:jumlahNode
        arsitekturNode.node(i).x=rand*arsitekturJaringan.luasArea.panjang;
        arsitekturNode.node(i).y=rand*arsitekturJaringan.luasArea.lebar;
        arsitekturNode.node(i).G=0;
        arsitekturNode.node(i).type='N';
        arsitekturNode.node(i).energi = arsitekturJaringan.energi.init;
        arsitekturNode.node(i).CH=-1;
        arsitekturNode.dead(i)=0;
    end
    
    arsitekturNode.jumlahNode=jumlahNode;
    arsitekturNode.nodeMati=0;
end

