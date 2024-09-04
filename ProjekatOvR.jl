using DataFrames
using CSV
using StatsBase
using StatsModels
using Statistics
using Plots, StatsPlots
using ROCAnalysis
using GLM
using Lathe



df = DataFrame(CSV.File("somedata.csv"))


fm1 = @formula(IQ_Zone==0~Working_Memory_Score+Attention_Span+Logical_Reasoning_Score+Study_Hours+Sleep_Hours)
fm2 = @formula(IQ_Zone==1~Working_Memory_Score+Attention_Span+Logical_Reasoning_Score+Study_Hours+Sleep_Hours)
fm3 = @formula(IQ_Zone==2~Working_Memory_Score+Attention_Span+Logical_Reasoning_Score+Study_Hours+Sleep_Hours)



dfTrain, dfTest = Lathe.preprocess.TrainTestSplit(df, .8)
logisticRegresr1 = glm(fm1,dfTrain, Binomial(), ProbitLink())
logisticRegresr2 = glm(fm2,dfTrain, Binomial(), ProbitLink())
logisticRegresr3 = glm(fm3,dfTrain, Binomial(), ProbitLink())


dataPredictTest1 = predict(logisticRegresr1, dfTest) 

dataPredictTest2 = predict(logisticRegresr2, dfTest) 

dataPredictTest3 = predict(logisticRegresr3, dfTest) 

dataPredictTestClass1 = repeat(0:0, length(dataPredictTest1))

dataPredictTestClass2 = repeat(0:0, length(dataPredictTest2))

dataPredictTestClass3 = repeat(0:0, length(dataPredictTest3))

for i in 1:length(dataPredictTest1)
    if dataPredictTest1[i] <0.5
        dataPredictTestClass1[i] = 0
    else
        dataPredictTestClass1[i] = 1
    end
end


for i in 1:length(dataPredictTest2)
    if dataPredictTest1[i] <0.5
        dataPredictTestClass2[i] = 0
    else
        dataPredictTestClass2[i] = 1
    end
end

for i in 1:length(dataPredictTest3)
    if dataPredictTest3[i] <0.5
        dataPredictTestClass3[i] = 0
    else
        dataPredictTestClass3[i] = 1
    end
end

iqzona0 = 0;
iqzona1 = 0;
iqzona2 = 0;
nevalja0 = 1;
nevalja1 = 1;
nevalja2 = 1;


for i in 1:length(dataPredictTestClass1)
    if dfTest.IQ_Zone[i] == 0 && dataPredictTestClass1[i] == 1
        global iqzona0+=1
    elseif  dfTest.IQ_Zone[i] == 0 && dataPredictTestClass1[i] == 0
        global nevalja0+=1
    elseif  dfTest.IQ_Zone[i] != 0 && dataPredictTestClass1[i] == 1
        global nevalja0+=1
    end    
end


for i in 1:length(dataPredictTestClass2)
    if dfTest.IQ_Zone[i] == 1 && dataPredictTestClass2[i] == 1
        global iqzona1+=1
    elseif  dfTest.IQ_Zone[i] == 0 && dataPredictTestClass2[i] == 0
        global nevalja1+=1
    elseif  dfTest.IQ_Zone[i] != 1 && dataPredictTestClass2[i] == 1
        global nevalja1+=1
    end    
end


for i in 1:length(dataPredictTestClass3)
    if dfTest.IQ_Zone[i] == 2 && dataPredictTestClass3[i] == 1
        global iqzona2+=1
    elseif  dfTest.IQ_Zone[i] == 0 && dataPredictTestClass3[i] == 0
        global nevalja2+=1
    elseif  dfTest.IQ_Zone[i] != 2 && dataPredictTestClass3[i] == 1
        global nevalja2+=1
    end    
end


procenat0 = iqzona0/nevalja0 *100
procenat1 = iqzona1/nevalja1 *100
procenat2 = iqzona2/nevalja2 *100

println("procenat tacnosti pogadjanja za prvu grupu $procenat0 %")
println("procenat tacnosti pogadjanja za drugu grupu $procenat1 %")
println("procenat tacnosti pogadjanja za trecu grupu $procenat2 %")

ukupno = iqzona0 + iqzona1 + iqzona2;

sanse1 = iqzona0/ukupno * 100;
sanse2 = iqzona1/ukupno * 100;
sanse3 = iqzona2/ukupno * 100;

println("Sanse da bude prva grupa na osnovu parametara je $sanse1 %")
println("Sanse da bude druga grupa na osnovu parametara je $sanse2 %")
println("Sanse da bude treca grupa na osnovu parametara je $sanse3 %")






