% 191124

%% for continuous data (intan 32 channel + 3 aux)
m = memmapfile('continuous.dat','Format','int16');
data_continous = reshape(m.Data, 35, []);
clear m

% for timestamp.npy readNPYheader
%[shape, dataType, fortranOrder, littleEndian, totalHeaderLength, ~] = readNPYheader('timestamps.npy');

% for timestamp.npy readNPYdata
ts_continous = readNPY('timestamps.npy');

%% for event data
channel_states = readNPY('channel_states.npy');
channels = readNPY('channels.npy');
full_words = readNPY('full_words.npy');
timestamps = readNPY('timestamps.npy');

%% JSON metafile
