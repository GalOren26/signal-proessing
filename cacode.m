function CA_Final = cacode(chipRate, fs, m_samples)
%cacode returns Gold Code for GPS satellite ID n = 1-32
%   chipRate -> number of chips per second = 1.023M ship/sec
%   m_samples -> number of samples that recorded
%   fs -> sampling freqency
%   nfs -> sampling rate

tap = [2 6 ; 3 7 ; 4 8 ; 5 9 ; 1 9 ; 2 10 ; 1 8 ;
       2 9 ; 3 10 ; 2 3 ; 3 4 ; 5 6 ; 6 7 ; 7 8 ;
       8 9 ; 9 10 ; 1 4 ; 2 5 ; 3 6 ; 4 7 ; 5 8 ;
       6 9 ; 1 3 ; 4 6 ; 5 7 ; 6 8 ; 7 9 ; 8 10;
       1 6 ; 2 7 ; 3 8 ; 4 9];

% Initial state
G1 = ones(1,10);
G2 = G1;

%%
s1 = tap(:,1);
s2 = tap(:,2);

%%
g1 = zeros(10,1);
g2 = zeros(10,1);
ca = zeros(1,1023);
CA = zeros(32,1023);

%% genrat Gold code
for i=1:32
    for j=1:1023
        g1(j) = G1(10);
        % G1 = 1+X^3+X^10
        temp1 = mod(G1(3)+G1(10),2); 
        % rotetion
        G1(2:10) = G1(1:9);
        G1(1) = temp1;
        
        g2(j) = mod(G2(s1(i))+G2(s2(i)),2);
        % G2 = 1+X^2+X^3+X^6+X^8+X^9+X^10
        temp2 = mod(G2(2)+G2(3)+G2(6)+G2(8)+G2(9)+G2(10),2);
        % rotetion
        G2(2:10) = G2(1:9);
        G2(1) = temp2;
        ca(j) = mod(g1(j)+g2(j),2);
        
    end
    CA(i,:) = ca;   
end

%% generating PRN at chipRate 1.023M chip/sec and sampling 

n = length(CA(1,:));

for j=1:32
    for i = 1:m_samples
        if mod(ceil(i*chipRate/fs),n)==0
        	CA_samp(i) = CA(j,n);
        else
            CA_samp(i) = CA(j,mod(ceil(i*chipRate/fs),n));
        end
    end
    CA_Final (j,:) = CA_samp;
end