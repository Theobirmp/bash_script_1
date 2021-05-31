#! /bin/bash

virusesFile=$1
countriesFile=$2
numLines=$3
duplicatesAllowed=$4

count=0

#creates a table of unique ids (nothing to do with duplicates)
ids=($(shuf -i 0-9999 -n "$numLines"))  


mapfile -t countries_array < $countriesFile
mapfile -t viruses_array < $virusesFile
mapfile -t dis_array < $virusesFile #used to create the duplicates(it remembers which viruses have not been used)

countries_array_length="${#countries_array[@]}"
viruses_array_length="${#viruses_array[@]}"

yes="YES"
no="NO"

myarray=()  #array used to >> data to outut.txt
dup_array=() #used to create the duplicates
temp_dup_array=()
dis_array=(${viruses_array[*]}) 

s=aeiouqwrtpsdfghjklzxcvnm #used to create random strings



for ((i=0; i<$numLines; i++ ))
do
    myarray+=("${ids[$i]}")                              #id
    #name=$(tr -dc A-Za-z </dev/urandom | head -c  6)  #>> output.txt  #name
    #myarray+=($name)   
    p=$(( $RANDOM % 22))
    name=${s:$p:12}
    myarray+=("$name")  
    p=$(( $RANDOM % 22))
    surname=${s:$p:12}
    myarray+=("$surname")   
    country_num=$((RANDOM%$countries_array_length))      #country
    country=${countries_array[$country_num]}
    myarray+=("$country") 
    age=$(( ( RANDOM % 120 )  + 1 ))            #age
    myarray+=("$age")
    dup_array=(${myarray[*]})
    temp_dup_array=(${myarray[*]})
    virus_num=$((RANDOM%$viruses_array_length))      #virus
    virus=${viruses_array[$virus_num]}
    myarray+=("$virus") 
    yes_no=$((RANDOM%2))
    if [ $yes_no -eq 0 ]
    then
        myarray+=("NO")                            #NO
    else
        myarray+=("YES")                          #YES
        myarray+=("$((RANDOM%30+1))-$((RANDOM%12+1))-$((RANDOM%21+1990))") #date
    fi
    echo "${myarray[*]}" >> output.txt
    #check for the creation of duplicates duplicates
    luck=$((RANDOM%2 )) 
    while [[ $luck -eq 0 ]] && [[ $duplicatesAllowed -eq 1 ]] && [[ i -lt $numLines-1 ]]
    do
        #we want to create a duplicate
        #we have set all the info up to age
    i=$((i+1))
    dis_array_length="${#dis_array[@]}"
    cur_virus_num=$((RANDOM%$dis_array_length))      #virus
    cur_virus=${dis_array[$cur_virus_num]}
    dup_array+=("$cur_virus")
    dis_array=( "${dis_array[@]/$cur_virus}" )

        yes_no=$((RANDOM%2))
        if [ $yes_no -eq 0 ]
        then
            dup_array+=("NO")                            #NO
        else
            dup_array+=("YES")                          #YES
            #dup_array+=("$((RANDOM%1+2020))-$((RANDOM%12+1))-$((RANDOM%28+1))") #date
            dup_array+=("$((RANDOM%30+1))-$((RANDOM%12+1))-$((RANDOM%21+1990))") #date
        fi
        echo "${dup_array[*]}" >> output.txt
        dup_array=(${temp_dup_array[*]})
        luck=$((RANDOM%2 )) #reset luck
    done    
    dis_array=(${viruses_array[*]}) 
    myarray=()
    dup_array=()
done
#printf "${myarray[*]}" >> output.txt

#touch duplicate 
#:> duplicate
#echo temp>>duplicate
#while grep -q $temp duplicate ;
#do
#vale neo io

#1000 john papadopoulos Greece 52 covid YES 27-2-2020

