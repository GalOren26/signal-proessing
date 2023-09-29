# extracting data from IQ signals of GPS

This project is a foundational step in constructing a GPS receiver. It involves extracting data from IQ signals of GPS recordings,
identifying the Doppler shift, and discerning the C/A code (Coarse/Acquisition code), which enables satellites to broadcast on identical frequencies without mutual interference.

Several methods have been implemented for this purpose:
1.Serial Search Method:
This method iteratively scans through all possible satellites (32 in total), C/A code phases, and Doppler frequency shifts to pinpoint the maximum correlation. Subsequently, it determines the presence of a satellite based on a predefined SNR (Signal-to-Noise Ratio) threshold.

2.Parallel Frequency Search Method:
Rather than iterating over Doppler shifts, this method computes the correlation between the signal and the shifted C/A code. It then employs the maximum value of the FFT (Fast Fourier Transform) to ascertain the Doppler shift.

3.Parallel Code Phase Method:
This method, instead of iterating over different possible code phases, calculates the correlation by leveraging the properties of multiplication and cyclic convolution in the frequency domain using FFT.

