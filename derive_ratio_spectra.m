function [ratio_spectra, ratio_strings] = derive_ratio_spectra(vis_spectra)

    % for completeness sake we do all the possible pairs, even though
    % especially with alpha-bands only, you hardly have any overlap with
    % SWS and LWS cones
    
    sensitivities_names = fieldnames(vis_spectra);
    no_of_spectra = length(sensitivities_names);    
    indices = linspace(1, no_of_spectra, no_of_spectra);
    pair_combinations = nchoosek(indices,2); % Binomial coefficient or all combinations
    
    % In other how many pairwise comparison can we make, and with 6
    % sensitivities now we get 15 different combinations. So in theory you
    % could have 15 different illuminants for example in your silent
    % substitution lighting system to have one for each optimal separation
    
    % Define all ratios    
    
    for pair = 1 : length(pair_combinations)
               
        % shorter variable names
        ind1 = pair_combinations(pair,1);
        ind2 = pair_combinations(pair,2);
        
        % define ratio name
        name_1st = sensitivities_names{ind1};
        name_2nd = sensitivities_names{ind2};          
        ratio_name{pair} = [name_1st, '_', name_2nd];
        ratio_strings{pair} = [name_1st, ' / ', name_2nd];
        
        % calculate the ratio
        spec1 = vis_spectra.(sensitivities_names{ind1})(:,2);
        spec2 = vis_spectra.(sensitivities_names{ind2})(:,2);
        
        ratio_spectra.(ratio_name{pair})(:,1) = vis_spectra.(sensitivities_names{ind1})(:,1);
        ratio_spectra.(ratio_name{pair})(:,2) = spec1 ./ spec2;               
        
    end
    
end