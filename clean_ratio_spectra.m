function [lambda, spectra_mat_LOG_abs_trim, peaks] = ...
    clean_ratio_spectra(vis_spectra, ratio_spectra, ratio_strings, threshold)

    % convert from structure to matrix for easier plotting
    [lambda, spectra_mat] = convert_spectra_str_to_matrix(ratio_spectra);
    
    % the original sensitivities
    [~, vis_spectra_mat] = convert_spectra_str_to_matrix(vis_spectra);
    
    % sum together as the compound spectrum for quick'n'dirty filtering
    vis_spectra_sum = sum(vis_spectra_mat, 2);
    vis_spectra_sum = vis_spectra_sum / max(vis_spectra_sum(:));
        
    % Log conversion
    spectra_mat_LOG = log10(spectra_mat);
    spectra_mat_LOG_abs = abs(spectra_mat_LOG);
    
    % Do quick'n'dirty filtering of this ABS LOG as we now get values from
    % very long-wavelength tails that do not make any sense in practical
    % sense    
    aboveThreshold = vis_spectra_sum > threshold;
    
    % Trim now the "too noisy values"
    spectra_mat_LOG_abs_trim1 = spectra_mat_LOG_abs;
    spectra_mat_LOG_abs_trim1(~aboveThreshold,:) = NaN;    
    
    % This is not enough actually, so we can do heuristic guess as we have
    % only photoreceptor above 555 nm for example, and MWS has a peak at
    % 542 nm. So we conditionally set pairs not involving LWS to zero below
    % MWS peak for example
    cutoff = 542;
    except = 'LWS';
    spectra_mat_LOG_abs_trim = heuristic_filter_for_ratio_spectra(lambda, spectra_mat_LOG_abs_trim1, ratio_strings, cutoff, except);
    
    % get the maximal separations per pair
    % first remove infinite values
    spectra_mat_LOG_abs_trim(isinf(spectra_mat_LOG_abs_trim)) = NaN;
    [spectra_max_values, max_indices] = max(spectra_mat_LOG_abs_trim);
    max_spectra = lambda(max_indices);
    
    % Combine wavelengths and max values
    peaks.lambda = max_spectra;
    peaks.maxValue = spectra_max_values;
    peaks.lambdaIndex = max_indices;
    
end

function spectra_mat = heuristic_filter_for_ratio_spectra(lambda, spectra_mat, ...
                                                     ratio_strings, cutoff, except)

    NaN_lambda = lambda > cutoff;
                                                 
    for s = 1 : size(spectra_mat, 2)
       
        % NO LWS found (or the except value more generally)
        if isempty(strfind(ratio_strings{s}, except))            
            spectra_mat(NaN_lambda,s) = NaN;
            
        % LWS Found
        else            
                        
        end
        
    end

end

