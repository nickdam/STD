%Filtragem utilizando Filtro Rejeita-Faixa STD

% ParÃ¢metro 4: f1=2.2 kHz e f2=2.5 kHz

clf;
clear;

[x, fs] = audioread('exemplo.wav'); % Carrega o Ã¡udio e a taxa de amostragem

t = (0:length(x)-1) / fs; % Cria um vetor de tempo

f1 = 2200 %frequencia 1 do ruÃ­do em Hz
f2 = 2500 %frequencia 2 do ruÃ­do em Hz

n = 1*cos(2 * pi * f1 * t') + 1*cos(2 * pi * f2 * t'); % Sinal do ruÃ­do

z = x + n; % Sinal do Ã¡udio com ruÃ­do

audiowrite ('audio_com_ruido.wav', z, fs);

%sound(z, fs);

% Frequencias de corte do Rejeita-Faixa
corte1 = f1 - 300;
corte2 = f1 - 100;
corte3 = f2 + 100;
corte4 = f2 + 300;

bandas = [0, corte1, corte2, corte3, corte4, fs/2] / (fs/2);

r = [1, 1, 0, 0, 1, 1];

ordem = 500; % ordem do filtro

b = remez (ordem, bandas, r);

y = filter(b,1,z);

%audiowrite ('audio_filtrado.wav', y, fs);


% Sinal original
subplot(3, 1, 1);
plot(t, x);
title('Sinal de Ã�udio Original x[n]');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Sinal com ruÃ­do
subplot(3, 1, 2);
plot(t, z);
title('Sinal de Ã�udio com ruÃ­do z[n] = x[n] + n[n]');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Sinal filtrado
subplot(3, 1, 3);
plot(t, y);
title('Sinal de Ã�udio Filtrado y[n]');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Transformada dos sinais
X = fftshift(fft(x));
Z = fftshift(fft(z));
Y = fftshift(fft(y));

f = linspace(-fs/2, fs/2, length(X));

figure;
subplot(3, 1, 1);
plot(f, abs(X));
title('Espectro do Sinal Original X[f]');
xlabel('FrequÃªncia (Hz)');
ylabel('Magnitude');

subplot(3, 1, 2);
plot(f, abs(Z));
title('Espectro do Sinal Contaminado Z[f]');
xlabel('FrequÃªncia (Hz)');
ylabel('Magnitude');

subplot(3, 1, 3);
plot(f, abs(Y));
title('Espectro do Sinal Filtrado Y[f]');
xlabel('FrequÃªncia (Hz)');
ylabel('Magnitude');

%Resposta em frequencia do filtro
[H, f_freq] = freqz(b,1,1024,fs);

figure;
subplot(2, 1, 1);
plot(f_freq, abs(H));
title('Resposta em Magnitude do Filtro');
xlabel('FrequÃªncia (Hz)');
ylabel('|H(f)|');

subplot(2, 1, 2);
plot(f_freq, unwrap(angle(H)));
title('Resposta de Fase do Filtro');
xlabel('FrequÃªncia (Hz)');
ylabel('Fase (radianos)');

sound(x,fs);
