
%% load continous data
[data_ch1, timestamps_ch1, info_ch1] = load_open_ephys_data('100_CH1.continuous');

%% load event data
[data_event, timestamps_event, info_event] = load_open_ephys_data('all_channels.events');
