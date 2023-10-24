function chi = state2chi(Rot,varargin)
if(nargin == 2)
    PosAmers = varargin{1};
    NbAmers = size(PosAmers,2);
    chi = eye(3+NbAmers);
    chi(1:3,1:3) = Rot;
    if NbAmers > 0
        chi(1:3,4:end) = PosAmers;
    end
else
%     chi = [Rot v x; zeros(2,3) eye(2)];
    chi = Rot;

end
end
