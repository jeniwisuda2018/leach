function [ jaringan ] = jaringan( luasArea, lokasiBS)
    % luasArea luas area yang digunakan terdiri dari nilai panjang dan lebar
    % lokasiBS penempatan lokasi BS pada area jaringan

    % jika luasArea belum didefinisi maka akan dibuat default yaitu 100x100
    if ~exist('luasArea','var')
        luasArea.lebar=100;
        luasArea.panjang=100;
    end

    % jika lokasi BS belum ditentukan maka defaultnya adalah berada di tengah
    % area jaringan
    if ~exist('lokasiBS','var')
        lokasiBS.x=0.5*luasArea.panjang;
        lokasiBS.y=0.5*luasArea.lebar;
    end

    % energi yang digunakan dalam satuan joule dan semuanya dibuat default
    energi.init = 0.5;
    energi.transfer = 50*0.000000001;
    energi.receiver = 50*0.000000001;
    energi.freeSpace = 10*0.000000000001;
    energi.multiPath = 0.0013*0.000000000001;
    energi.aggr = 5*0.000000001;

    jaringan=struct('luasArea', luasArea, ...
        'lokasiBS', lokasiBS, ...
        'energi', energi);
end

