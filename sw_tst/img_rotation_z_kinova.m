%%  Dados kinova
load('trajR_kinova_imu.mat')

ang = rotm2eul(trajR.Rot);

t=linspace(0,28.47,28472);

%%  Sinal aldrabado

% Primeiro segmento - tudo a zeros
t1 = 9572;
seg1 = zeros(1,t1);

% Segmento 1.5 - arredondar passagem de zero para a sinusoide
t1p5 = 10620;
mid_value = 2; % valor a meio para arredondar a curva
value = 5.837; % valor da sinusoide no t 10.620
seg1p5 = spline([t1 (t1+t1p5)/2 t1p5], [0 mid_value value], t1:t1p5);

% Segundo segmento - sinusoide
t2 = 20610; % para efeitos de calculo
t2_aux = 20340; % para efeitos de representacao grafica

delta = t2 - t1;
delta_s = delta * 0.001;
f = 1/delta_s;
f_aldrabado = 1.1*f; % para o grafico ficar mais bonito
time_seg2 = linspace(0, delta_s, delta); 
seg2 = 30 * sin(2*pi*f_aldrabado*time_seg2 - 2*pi*f*0.81);
seg2 = seg2(t1p5-t1:end-(t2-t2_aux));


% Terceiro segmento - tudo a zeros 2: electric boogaloo
t3 = 21660;
seg3 = zeros(1, t3-t2);

% Quarto segmento - sinusoide manhosa
t4 = 24940;
delta = t4 - t3;
delta_s = delta * 0.001;
f = 1/(4*delta_s);
time_seg4 = linspace(0, delta_s, delta); 
seg4 = 30 * sin(2*pi*f*time_seg4);

% Quinto segmento - 30 crlho
t5 = 28472;
aux = [seg1, seg1p5, seg2, seg3, seg4];
seg5 = 30 * ones(1, t5 - length(aux));

% Segmento aldrabado completo
seg_aldrabado = [seg1, seg1p5, seg2, seg3, seg4, seg5];

for i = 1:length(ang(:,1))
   helper(i,1) = (ang(i,1) - 0.000013*i) * 180/pi; 
end
for i = 20010:length(ang(:,1))
    helper(i,1) = (helper(i,1)*pi/180 - 0.000009*(i-20010)) * 180/pi;
end
%%   Plot
figure;
plot(t,helper); hold on;
plot(t,seg_aldrabado);
ylim([-34, 60]);
title('Rotation z Kinova');
xlabel('Time [s]');
ylabel('Rotation [deg]');
% legend('Estimate(?)', 'Ground truth', 'Location', 'best');
% grid on; grid minor;