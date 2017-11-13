function S = aprNMI(C,X)

[n,m] = size(X);

nmi = [];
for i = 1:m
    nmi(i) = hs_mut_inf(X(:,i),C)./((sqrt(hs_mut_inf(X(:,i),X(:,i)))*sqrt(hs_mut_inf(C,C)))+1e-40);
end
tmpMI = nmi;
[nmi,id] = sort(nmi,'descend');

S = id(1);

flag = [];
for i = 1:m
    flag(i) = 0;
end

flag(id(1)) = 1;

for feature = 2:20
    mx = -1;
    next = 0;
    for i = 1:220
        if flag(i) == 0 && tmpMI(i) > 0.001
            redun = 0;
            [tmp k] = size(S);
            for j = 1:k
                redun = redun + hs_mut_inf(X(:,i),X(:,S(j)))/(sqrt(hs_mut_inf(X(:,i),X(:,i)))*sqrt(hs_mut_inf(X(:,S(j)),X(:,S(j)))));
            end
            G = hs_mut_inf(X(:,i),C)/(sqrt(hs_mut_inf(X(:,i),X(:,i)))*sqrt(hs_mut_inf(C,C))) - (1/k)*redun;
            if G > mx
                mx = G;
                next = i;
            end
        end
    end
    
    if mx < 0
        break;
    end
    
    if next > 0
        S(feature) = next;
        flag(next) = 1;
    end
end

end