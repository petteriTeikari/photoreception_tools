function [lambda, spectra_mat] = convert_spectra_str_to_matrix(spectra_str)

    names = fieldnames(spectra_str);
    no_of_spectra = length(names);
    
    lambda = spectra_str.(names{1})(:,1);
    spectra_mat = zeros(length(lambda), no_of_spectra);
    
    for s = 1 : no_of_spectra
        spectra_mat(:,s) = spectra_str.(names{s})(:,2);
    end

end