function outputFile = myFIR(filename, impulseResponse)
    [x, Fs] = audioread(filename);
    Nx = length(x);
    
    y=impulseResponse(1)*[x;0;0]+impulseResponse(2)*[0;x;0]+impulseResponse(3)*[0;0;x];
    Ny = length(y);
    
    xF = fft(x);
    yF = fft(y);
    
    fx = (0:(Nx-1)) * (Fs/Nx);
    fy = (0:(Ny-1)) * (Fs/Ny);
    
    plot(fx,20*log10(abs(xF)),fy,20*log10(abs(yF)));
    legend('Input', 'Output');
    xlabel('frequency');
    ylabel('dB');
    title('FIR');
    outputFile = 'fir_output.wav';
    audiowrite(outputFile,y, Fs);
end