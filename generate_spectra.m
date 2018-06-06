function [vis_spectra, vis_spectra_retinal, ratio_spectra, ratio_strings] = generate_spectra(param)

    % Use the default corneal human sensitivities
    if strcmp(param.spectra_set, 'default') 
                
        [vis_spectra, vis_spectra_retinal] = importSensitivities();
        
        % now derive the "action spectrum" for ratios 
        % between each action spectrum
        [ratio_spectra, ratio_strings] = derive_ratio_spectra(vis_spectra);                       
        
    end
    
end