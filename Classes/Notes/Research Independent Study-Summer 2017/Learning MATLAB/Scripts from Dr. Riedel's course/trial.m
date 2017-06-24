[rsa,csa]=size(A);
[rsb,csb]=size(B);
if csa==rsb
    C=zeros(rsa,csb);
    for i=1:rsa
        for j=1:csb
            for k=1:rsb
                C(i,j)=C(i,j)+A(i,k)*B(k,j)
            end
        end
    end
end
