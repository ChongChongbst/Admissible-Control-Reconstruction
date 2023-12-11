function data_out = dataUpdate(data_combined, data_full, index, new_ind)

%% The tree input have the same grid and dimension
k = size(data_full,4);
data_out = data_combined;
data_full_processed = data_full(:,:,:,k);

data_out(index) = data_full_processed(new_ind); 