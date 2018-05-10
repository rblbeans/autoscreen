#!/bin/bash
dir="/var/www/html/cacti/$(date +%F)"
egrep "Current|Maximum" "$dir"/data.txt >21.txt
awk '{print $3,$4, $9,$10}' 21.txt >22.txt
sed -i 's#[.]$##' 22.txt
a1=(`awk '{print $1}' 22.txt `)   
a2=(`awk '{print $2}' 22.txt `)   
b1=(`awk '{print $3}' 22.txt `)   
b2=(`awk '{print $4}' 22.txt `)   
for((i=0;i<18;i+=2))               
do                                 
  last_in_number=${a1[$i]}                    
  last_in_unit=${a2[$i]}                       
  last_in=$last_in_number$last_in_unit          
  echo $last_in_unit >> in_unit                 
  echo $last_in_number >> first                 
done                               

for((i=1;i<18;i+=2))   
do                                
  last_out_number=(${a1[$i]})       
  last_out_unit=(${a2[$i]})                
  last_out=$last_out_number$last_out_unit   
  echo $last_out_unit >> out_unit           
  echo $last_out_number >> second           
done

awk 'NR==FNR{a[i]=$0;i++}NR>FNR{print a[j]" "$0;j++}' first in_unit > in_final  
awk 'NR==FNR{a[i]=$0;i++}NR>FNR{print a[j]" "$0;j++}' second out_unit > out_final  
awk 'NR==FNR{a[i]=$0;i++}NR>FNR{print a[j]" "$0;j++}' in_final out_final > final  

cat final |while read line    
do                                    
  in=`echo $line|awk '{print $1}'`      
  out=`echo $line|awk '{print $3}'`    
  a=`echo $line |awk '{print $2}'`  
  b=`echo $line |awk '{print $4}'`
  resault=`echo "$in > $out" |bc`
 
 if [[ "$a" == "M" && "$b" == "M" && $resault -eq 1 ]];then    
     now=$in
     now_unit="M"
 elif [[ "$a" == "M" && "$b" == "M" && $resault -ne 1 ]];then
     now="$out"
     now_unit="M" 
 elif [[ "$a" == "M" && "$b" == "G" ]];then
     now="$out"
     now_unit="G"
 elif [[ "$a" == "G" && "$b" == "M" ]];then
     now="$in"
     now_unit="G" 
 elif [[ "$a" == "G" && "$b" == "G" &&  $resault -eq 1 ]];then
     now="$in"
     now_unit="G"    
 elif [[ "$a" == "G" && "$b" == "G" &&  $resault -ne 1 ]];then
     now="$out"
     now_unit="G"
 elif [[ "$a" == "k" && "$b" == "k" &&  $resault -eq 1 ]];then
      now="$in"
      now_unit="k"
 elif [[ "$a" == "k" && "$b" == "k" &&  $resault -ne 1 ]];then
      now="$out"
      now_unit="k"
 elif [[ "$a" == "k" && "$b" == "M" ]];then
      now="$out"
      now_unit="M"
 elif [[ "$a" == "M" && "$b" == "k" ]];then
      now="$in"
      now_unit="M"
fi         
echo $now$now_unit >>${dir}/current
rm -rf final first  in_unit  out_unit  second in_final out_final
done  
    
sleep 2

for((i=0;i<18;i+=2))               
do                                 
  last_in_number=${b1[$i]}                    
  last_in_unit=${b2[$i]}                       
  last_in=$last_in_number$last_in_unit          
  echo $last_in_unit >> in_unit                 
  echo $last_in_number >> first                 
done                               

for((i=1;i<18;i+=2))   
do                                
  last_out_number=(${b1[$i]})       
  last_out_unit=(${b2[$i]})                
  last_out=$last_out_number$last_out_unit   
  echo $last_out_unit >> out_unit           
  echo $last_out_number >> second           
done

awk 'NR==FNR{a[i]=$0;i++}NR>FNR{print a[j]" "$0;j++}' first in_unit > in_final  
awk 'NR==FNR{a[i]=$0;i++}NR>FNR{print a[j]" "$0;j++}' second out_unit > out_final
awk 'NR==FNR{a[i]=$0;i++}NR>FNR{print a[j]" "$0;j++}' in_final out_final > final

cat final |while read line    
do                                    
  in=`echo $line|awk '{print $1}'`      
  out=`echo $line|awk '{print $3}'`    
  a=`echo $line |awk '{print $2}'`  
  b=`echo $line |awk '{print $4}'`
  resault=`echo "$in > $out" |bc`
 
 if [[ "$a" == "M" && "$b" == "M" && $resault -eq 1 ]];then    
     now=$in
     now_unit="M"
 elif [[ "$a" == "M" && "$b" == "M" && $resault -ne 1 ]];then
     now="$out"
     now_unit="M" 
 elif [[ "$a" == "M" && "$b" == "G" ]];then
     now="$out"
     now_unit="G"
 elif [[ "$a" == "G" && "$b" == "M" ]];then
     now="$in"
     now_unit="G" 
 elif [[ "$a" == "G" && "$b" == "G" &&  $resault -eq 1 ]];then
     now="$in"
     now_unit="G"    
 elif [[ "$a" == "G" && "$b" == "G" &&  $resault -ne 1 ]];then
     now="$out"
     now_unit="G"               
fi         
echo $now$now_unit >>${dir}/max
rm -rf final first in_unit out_unit second in_final out_final
done
rm -rf {21,22}.txt 
