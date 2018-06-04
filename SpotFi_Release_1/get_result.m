function get_result()
    for i=1:10
        results_1(i).result = start_spotfi('data/2m-30.dat',(i-1)*10+1);
        results_2(i).result = start_spotfi('data/4m-30.dat',(i-1)*10+1);
        results_3(i).result = start_spotfi('data/2m-60.dat',(i-1)*10+1);
        results_4(i).result = start_spotfi('data/4m-60.dat',(i-1)*10+1);
        results_5(i).result = start_spotfi('data/2m-90-1.dat',(i-1)*10+1);
        results_6(i).result = start_spotfi('data/4m-90-1.dat',(i-1)*10+1);
        results_7(i).result = start_spotfi('data/2m-120-1.dat',(i-1)*10+1);
        results_8(i).result = start_spotfi('data/4m-120-1.dat',(i-1)*10+1);
        results_9(i).result = start_spotfi('data/2m-150-1.dat',(i-1)*10+1);
        results_10(i).result = start_spotfi('data/4m-150-1.dat',(i-1)*10+1);
    end
end