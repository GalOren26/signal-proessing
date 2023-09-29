

from scipy import signal
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile
from scipy import ndimage


RF_CENTER_FREQ = 100e6
SAMPLE_RATE = 1e6
NFFT_welch=2**14
Res=SAMPLE_RATE/NFFT_welch
"""
This short exercise will involve spectrum signal detection and FM radio demodulation.
Your goals are to:
    1. Identify signals found in raw IQ samples received through a SDR.
    2. FM Demodulate the detected signals and save the resulting audio to a WAV file.
The sample rate and RF center frequency of the IQ samples are given as constants below.
Write your code in the main function below.

Input:
    IQ samples in binary complex float(single precision) format.
    
Output:
    1. Table printout of signals found inside the samples with the following features:
        - RF Center Frequency in Hz
        - Bandwidth in Hz
        - Power Spectrum in dBm
    2. Audio file for each detected signal
"""

samples = np.fromfile("samples.dat", dtype=np.complex64)
samples = samples - np.mean(samples)


def Filterband(samples, fc,stop_band_freq,fs):

    # Calculate the normalized cutoff frequency
    normalized_cutoff = fc / (0.5 * fs)
    normalized_stop_band=stop_band_freq/(0.5 * fs)
    # Additional parameters for the Butterworth filter design
    passband_attenuation = 0.5 # Maximum passband attenuation in dB
    stopband_attenuation = 30 # Minimum stopband attenuation in dB

    # Estimate the minimum filter order using the Butterworth design
    order, _ = signal.buttord(normalized_cutoff, normalized_stop_band,
                            passband_attenuation, stopband_attenuation)
    b, a = signal.butter(order, normalized_cutoff, btype='low', analog=False, output='ba')
    # Apply the forward and backward filtering (zero-phase filtering)
    filtered_signal = signal.filtfilt(b, a, samples)
    return filtered_signal


# Spectrum analysis
# plt.specgram(samples,NFFT=1024,Fs=SAMPLE_RATE,noverlap=524)
# plt.colorbar(label='Power Spectral Density (dB/Hz)')
# plt.xlabel('Time (s)')
# plt.ylabel('Frequency (dbm/Hz)')

# regular psd 

# frequencies, psd = signal.periodogram(samples, fs=SAMPLE_RATE,nfft=1024) # Hann window an overlap of 50% 
# frequencies = np.fft.fftshift(frequencies)
# psd = np.fft.fftshift(psd)
# power_spectrum = 10 * np.log10(psd) + 30  # Convert power to dBm
# plt.plot(frequencies,power_spectrum)


# welch psd
frequencies, psd = signal.welch(samples, fs=SAMPLE_RATE, nperseg=NFFT_welch) # Hann window an overlap of 50% 
frequencies = np.fft.fftshift(frequencies)
psd = np.fft.fftshift(psd)
power_spectrum = 10 * np.log10(psd) + 30  # Convert power to dBm

# Signal detection
power_spectrum=ndimage.median_filter(power_spectrum,10)# filter noise
threshold = np.mean(power_spectrum) + 10  # Adjust the threshold as needed
#we want distance of at least 75khz between channels-distance between chanels
peaks,_=signal.find_peaks(power_spectrum, distance=1250,width=20)# 1250*Res~75khz,res= (1M/NFFT_welch),width = 20*res~1.2khz


detected_signals_carriers = []
detected_signals=[]
signal.find_peaks(power_spectrum, distance=500,width=20)
window_size=450# 60hz*450=25khz
# we want each point will be maxima in its sourrundings- we define sourrunding as 25Khz each size 
for idx in peaks:
        if window_size <= idx < len(power_spectrum) - window_size:
         if power_spectrum[idx] >= np.max(power_spectrum[idx - window_size:idx + window_size + 1]):
            detected_signals_carriers.append(idx)

# Print table of detected signals
print("Detected Signals:")
print("-----------------")
print("RF Center Freq (Hz)  Bandwidth (Hz)  Power Spectrum (dBm)")

for signal_idx in detected_signals_carriers:
    # Calculate signal properties
    signal_start = int(signal_idx*Res - SAMPLE_RATE / 20)
    signal_end = int(signal_idx*Res + SAMPLE_RATE / 20)
    
    # Parameters for the Butterworth filter
    cutoff_frequency = 25e3  # Cutoff frequency in Hz
    stop_band_freq=50e3 # Stop frequency in Hz
    signal_bandwidth=stop_band_freq*2
    sample_rate = 1e6  # Sample rate in Hz
    fci=frequencies[signal_idx]*Res
    t=np.linspace(0,1,len(samples))
    shifted_signals=samples*np.exp(-1j * 2 * np.pi * fci * t)
    filtered_signal=Filterband(shifted_signals, cutoff_frequency,stop_band_freq,SAMPLE_RATE)
    detected_signals.append(filtered_signal)
    signal_power_spectrum = 10 * np.log10(np.mean(np.abs(filtered_signal) ** 2)) + 30
    
    
    # FM demodulation
    audio_signal = np.unwrap(np.angle(filtered_signal[1:] * np.conj(filtered_signal[:-1])))
    audio_data = signal.resample(audio_signal, int(signal_bandwidth / SAMPLE_RATE * len(audio_signal)))
    # Save audio to WAV file
    wavfile.write(f'detected_signal_{i}.wav', int(SAMPLE_RATE / 48e3), audio_signal)

# Print signal information
print("Detected Signals:")
print("RF Center Frequency (Hz) \t Bandwidth (Hz) \t Power Spectrum (dBm)")
for i, (freq, bandwidth, power) in enumerate(detected_signals_carriers):
    print(f"{freq:.2f} \t\t\t {bandwidth:.2f} \t\t {power:.2f}")
    
    
    
 
 
 


 
 
    
  #demiate to get relavent signal 
# csamples_filtered = decimate(csamples_ac, 10,ftype='fir',zero_phase=True);
    
    
#     # Demodulation
# x = np.diff(np.unwrap(np.angle(x)))

# # De-emphasis filter, H(s) = 1/(RC*s + 1), implemented as IIR via bilinear transform
# bz, az = signal.bilinear(1, [75e-6, 1], fs=SAMPLE_RATE)
# x = signal.lfilter(bz, az, x)

# # decimate by 6 to get mono audio
# x = x[::6]
# sample_rate_audio = SAMPLE_RATE/6

# # normalize volume so its between -1 and +1
# x /= np.max(np.abs(x))

# # some machines want int16s
# x *= 32767
# x = x.astype(np.int16)

# # Save to wav file, you can open this in Audacity for example
# wavfile.write('fm.wav', int(sample_rate_audio), x)