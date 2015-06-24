function [ h ] = RootRaiseCosine( alpha, taps, Tc )
t = taps/2;
t_Tc = -t:1/Tc:t;
rrcNum = sin((pi*t_Tc)*(1-alpha))+(4*alpha*t_Tc).*cos((pi*t_Tc)*(1+alpha));
rrcDen = (pi*t_Tc).*(1-(4*alpha*t_Tc).^2);
h = rrcNum./rrcDen;

% L'hopital's rule Implementation
% -------------------------------

indexZ = find(t_Tc==0);                 % Find associated index points
indexAlpha = find(t_Tc==1/(4*alpha));

if isempty(indexZ)~= 1
    for i = 1:length(indexZ)
        h(indexZ(i)) = (1-alpha)+(4*alpha)/pi;
    end
end
if isempty(indexAlpha) ~= 1
    for i = 1:length(indexAlpha)
        h(indexAlpha(i)) = (alpha/sqrt(2))*((1+(2/pi))*sin(pi/(4*alpha))+(1-(2/pi))*cos(pi/(4*alpha)));
    end
end
h = h/Tc; % Normalised
end

% os_rate = Tc;
% a=alpha;
% taps = taps/2;
% t=[-taps:1/os_rate:taps];
% for i=1:1:length(t)
%     if (t(i)~=0)
%         r(i) = (sin(pi*t(i)*(1-a))+4*a*t(i).*cos(pi*t(i)*(1+a)))...
%             ./(pi*t(i).*(1-(4*a*t(i)).^2));
%     else
%         r(i)=1;
%     end
% end
% h=r./sqrt(sum(r.^2));