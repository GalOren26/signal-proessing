clear all
load('gps_iq')
method=1;
samples=size(data,2);
fs=2.6e6;
res=100;
maxDoppler=4000;
codes=cacode(1.023e6,fs,samples)*2-1;
index=1;
j=sqrt(-1);
aquisition.SNR=zeros(32,1);
aquisition.Doppler=zeros(32,1);
aquisition.CodePhase=zeros(32,1);
if method== 1
    %%%%%%% Serial search method %%%%%%%
    tic
    for sat=2%:1:32
        shiftedcode=codes(sat,:);
        for code_phase=1:1:2600
            index=1;
            for dopler_shift=-maxDoppler:res:maxDoppler
                
                shifted_data=data.*exp(j*2*pi*dopler_shift.*(1:1:samples)/fs);
                correlation(code_phase,index)= abs(sum(shiftedcode.*shifted_data,2));
                index=index+1;
            end
            shiftedcode=circshift(shiftedcode,[1 1]);

        end
        mesh(correlation)
        maximum = max(correlation,[],'all');
        [codephase,dopshift]=find(correlation==maximum);
        SNR=10*log10(max(correlation(codephase,:))^2 /mean(correlation(codephase,:).^2));

        if(SNR>11)
            aquisition.SNR(sat,1)=SNR;
            aquisition.Doppler(sat,1)=dopshift*res-maxDoppler;
            aquisition.CodePhase(sat,1)=codephase;
        end

    end
    toc
elseif method==2
    
    
    for sat=1:1:32    
        sat
        for CodePhase=1:1:2600

            X=abs(fft(circshift(codes(sat,:),[1 CodePhase]).*data)/samples);
    %         correlation(code_phase,:)=X;
            SNR=10*log10(max(X.^2)/mean(X.^2));
            if(SNR>19)% found sattelite
                figure()
%                 plot(fs/samples*(0:length(X)-1)-fs/2,abs(fftshift(X))/samples);
                aquisition.SNR(sat,1)=SNR;
                Doppler_Shift=find(X==max(X))*fs/samples;
                aquisition.Doppler(sat,1)=Doppler_Shift;
                aquisition.CodePhase(sat,1)=CodePhase;
                break;
            end
        end

    end
else
    for sat=1:1:32
        index=1
        X_Conj=conj(fft(codes(sat,:)));
        for dopler_shift=-maxDoppler:res:maxDoppler
            D=fft(data.*exp(j*2*pi*dopler_shift.*(1:1:samples)/fs));
            output=abs(ifft(D.*X_Conj));
        %         plot((1:1:5000),output)
            correlation(:,index)=output;
            index=index+1;
        end
        figure
            mesh(correlation)
        maximum = max(correlation,[],'all');
        [codephase,dopshift]=find(correlation==maximum);
        SNR=10*log10(correlation(codephase,dopshift)^2 /mean(correlation(:,dopshift).^2));

        if(SNR>19)
            aquisition.SNR(sat,1)=SNR;
            aquisition.Doppler(sat,1)=dopshift*res-maxDoppler;
            aquisition.CodePhase(sat,1)=codephase;
        end
    end
end



% dopshift=dopshift*res-maxDoppler;
% %%%%%%% parallel frequenct search method %%%%%%%
% X=abs(fft(circshift(codes(sat,:),[1 572]).*data));
% plot(fs/samples*(0:length(X)-1)-fs/2,abs(fftshift(X))/samples);
% grid on;
% xlabel('Frequency (Hz)')
% ylabel('Magnitude')
% title('Two-sided spectrum')
% SNR(sat)=10*log10(max(X.^2)/mean(X.^2));
% 

