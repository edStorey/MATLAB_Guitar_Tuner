clear all

% This calculates the distance from a power of 2 to the nearest note
dist = 523.25/512;

count = 1;

Notes_Freq = zeros(12,8);

% Create Note array
for n = 4 : 12
    
    for j = 0:11
        
        Note = dist*2^(n+(j/12));
        
        Notes_Freq(j+1,n-3) = round(100*Note)/100;
        
        count = count+1;
    end
    
end

% Read in note
[s, fs] = wavread('HighE.wav');

% Create FFT of note
ffts = abs(fft(s));

high_amp = 0;
freq_bin = 0;

% Find the highest peak in the FFT
for samp = 2:floor(length(ffts)/2)
    
    if ffts(samp) > high_amp
        high_amp = ffts(samp);
        freq_bin = samp;
    end
    
end

% Find the frequency of the highest peak
Freq = freq_bin*(fs/length(ffts));

Diff = 10000;
Prev_Diff = abs(Freq - Notes_Freq(1,1));
Notef = [1, 1];

% Find corresponding note
for N = 1:9
    
 for J = 1:12
    Diff = abs(Freq - Notes_Freq(J,N));
    
    if Diff < Prev_Diff
        
        Prev_Diff = Diff;
        Notef = [J, N];
    end
    
 end 
 
end


Notes = {'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B';};

% Calculate the correct note and how far from the correct frequency it is
Log_Freq = log2(Freq/dist);

Note_Num = Log_Freq - (Notef(2)+3);

Note_Diff = Note_Num -((Notef(1)-1)/12);

Note_Diff_Frac = Note_Diff/(1/12);

Note_Diff_Perc = round(Note_Diff_Frac*100);

Diff_ch = abs(int32(Note_Diff_Perc));

if Note_Diff_Perc >= 0 
    sign = '+';
else
    sign = '-';
end

% Create a string with the note
MusNote = strjoin([Notes(Notef(1))  sign num2str(Diff_ch) '%'], '')

% Play a sine wave of the correct frequency
t = 1/fs:1/fs:1;
f = Notes_Freq(Notef(1), Notef(2));
Sine_wave = sin(2*pi*Freq*t);

Sine_wave_audio = audioplayer(Sine_wave,fs);
play(Sine_wave_audio)

