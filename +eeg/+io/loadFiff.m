function data = loadFiff(filename,fs)
% This function will read MEG Fiff files

if(nargin<2)
    fs=250;
end

%hdr=fiff_read_meas_info(filename);
raw=fiff_setup_read_raw(filename);
hdr=raw.info;
d=fiff_read_raw_segment(raw);
aux=d(find(cat(hdr.chs.kind)==3),:);

if(fs<hdr.sfreq/2)
    n=round(hdr.sfreq/fs);
    d=resample(double(d'),1,n)';
    fs=hdr.sfreq/n;
else
    fs=hdr.sfreq;
end


data=eeg.core.Data;
lst=find([hdr.chs(:).kind]==1);
data.data=d(lst,:)';
data.time=[0:size(d,2)-1]/fs;
data.description=which(filename);

data.probe=eeg.core.MEGProbe(hdr);

stim=findstim(aux,hdr.sfreq,data.time);
data.stimulus=stim;
data.description=filename;
end

function stim = findstim(aux,fs,t)

aux2=aux;
stim=Dictionary;
for i=1:size(aux,1)
    s=diff(aux(i,:));
    s=s-s(1);
    s=s./sqrt(var(s));
    lst=find(s>20);
    lst(find(diff(lst)<50))=[];
    aux(i,:)=0;
    aux(i,[lst lst+1 lst+2])=1;
    onsets{i}=lst;
end
    
[r,p]=corrcoef(aux');

for i=1:size(aux,1)
    lst=find(p(i,i+1:end)<0.001);
    aux(i+lst,:)=0;
end
[i,j]=find(aux==1);
i=unique(i);

for j=1:length(i)
    if(length(onsets{i(j)})>30)
        st=nirs.design.StimulusEvents;
        st.name=['aux_' num2str(i(j))];
        k=dsearchn(t,onsets{i(j)}'/fs);
        st.onset=t(k);
        st.dur=ones(size(st.onset))*2*mean(diff(t));
        st.amp=ones(size(st.onset));
        stim(st.name)=st;
    end
end

end