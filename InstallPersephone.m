function InstallPersephone()
    % INSTALLPERSEPHONE Setup Persephone by automatically compiles all necessary
    %                   files for running Persephone

    % Add current directory to path
    base_dir = fileparts(mfilename('fullpath'));
    addpath(base_dir);

    % 1. Install Monitoring algorithm
    monitor_dir = fullfile(base_dir, 'src', 'monitor');
    cd(monitor_dir)
    fprintf('-- Building TQMonitor in %s\n', monitor_dir);
    mex('-g', ...
        '-compatibleArrayDims', ...
        '-output', 'TQMonitor', ...
        '-outdir', base_dir, ...
        '*.c');  
    cd(base_dir);
end
