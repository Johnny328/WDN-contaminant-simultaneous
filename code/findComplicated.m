function output_args = findComplicated( A, b )
%findComplicated Finds places where b is in A
%   Detailed explanation goes here
output_args = [];
    for(i=1:length(A))
        for(j=1:length(b))
            if(A(i)==b(j))
                output_args = [output_args i];
            end
        end
    end

end

