function [S, S_retinal] = importSensitivities(age)
    
    if nargin == 0
       age = 25; % standard observer 
    end

    % IMPORT LINEAR SENSITIVITIES
    % ---------------------------

        % 1st column - Wavelength
        % 2nd column - Sensitivity
        % (path, fileName, wavelengthCol, sensitivityCol, noOfHeaders, delimiter)
        
        % sorted now manually in ascending peak wavelength
        S.SWS = importSensitivityData(path, 'coneFundamentals_LINss10deg_380to780nm_1nm_Lin-E.txt', 1, 4, 1, '\t');
        S.opn4 = importSensitivityData(path, 'melanopic_humans_380to780_1nm_steps.txt', 1, 2, 1, '\t');       
        S.rods = importSensitivityData(path, 'v_lambda_Scotopic_1951e_LIN_380to780nm_1nm.txt', 1, 2, 1, '\t');
        S.MWS = importSensitivityData(path, 'coneFundamentals_LINss10deg_380to780nm_1nm_Lin-E.txt', 1, 3, 1, '\t');
        S.V = importSensitivityData(path, 'v_lambda_linCIE2008v10e_LIN_380to780nm_1nm.txt', 1, 2, 1, '\t');
        S.LWS = importSensitivityData(path, 'coneFundamentals_LINss10deg_380to780nm_1nm_Lin-E.txt', 1, 2, 1, '\t');             

        % function of LWS and MWS cones
        % From McDougal and Gamlin (2010)
        % https://doi.org/10.1016/j.visres.2009.10.012
        
            % p defines the LWS/MWS cone ratio. 
            % the LWS/MWS ratio was fixed at 1.625 (p = 0.62), 
            % which is the LWS/MWS ratio of the standard observer
            % Pokorny, Jin, & Smith (1993)
            % https://doi.org/10.1364/JOSAA.10.001304
            p = 0.62;        
        
        %{
        S.cones(:,1) = S.LWS(:,1);        
        S.cones(:,2) = (p .* S.LWS(:,2)) + ((p-1) .* S.MWS(:,2));
            S.cones(:,2) = S.cones(:,2) / max(S.cones(:,2)); % scale to 1 being the max
        %}
        
        % Change possible NaN-values to 0
        S.opn4(isnan(S.opn4) == 1) = 0;
        S.SWS(isnan(S.SWS) == 1) = 0;
        S.MWS(isnan(S.MWS) == 1) = 0;
        S.LWS(isnan(S.LWS) == 1) = 0; 
        S.rods(isnan(S.rods) == 1) = 0; 
        S.V(isnan(S.V) == 1) = 0;
        % S.cones(isnan(S.cones) == 1) = 0;
        
        % CORRECT FOR LENS ABSORPTION
        % ---------------------------    
        
        % TODO! Actually you could just generate these with the nomogram
        % function as the beta-bands won't emerge very well from here
        S_retinal.SWS = remove_absorbers_from_sensitivity(S.SWS, age);
        S_retinal.opn4 = remove_absorbers_from_sensitivity(S.opn4, age);
        S_retinal.rods = remove_absorbers_from_sensitivity(S.rods, age);
        S_retinal.MWS = remove_absorbers_from_sensitivity(S.MWS, age);
        S_retinal.V = remove_absorbers_from_sensitivity(S.V, age);
        S_retinal.LWS = remove_absorbers_from_sensitivity(S.LWS, age);        
        
        
function sensitivity = remove_absorbers_from_sensitivity(sensitivity, age)

    offset = 0.111; % 0.111 in van de Kraats and van Norren (2007)
    lambda = sensitivity(:,1);
    
    if age == 25 % standard observer age, as the tabulated visual sensitivities defined
        lensFilter = agedLensFilter(age, lambda, offset);
    end
        
    % TODO!
    % If you want to correct the rods and cones for macular pigment,
    % trickier then as it less homogoneously distributed over the
    % retina. And MelanopsinRGCs are in front of the macular pigment so
    % they do not need to be corrected for macular pigment
    
    % Another issue then sclera, iris and eyelid transmittances if you 
    % need to worry about those in your paradigm
    
    sensitivity(:,2) = sensitivity(:,2) ./ lensFilter;
    
    % Normalize back to unity
    sensitivity(:,2) = sensitivity(:,2) ./ max(sensitivity(:,2));
    
    

